"""H : Position ⇀ Operator x Attribution, genuinely partial this time.

D = dom(H) is an actual subset of Position, not a total function with a
sentinel value standing in for absence. Position carries its natural
order; ≤ is not a separate field, it's inherited from Position and can
be forgotten independently of D or the functions.

Three claimed elementary forgetting operations, one per KIND of symbol
in the signature (sort/domain, relation, function) -- NOT one per named
SA dimension:

  restrict-domain(D')      -- D ↦ D ∩ D'   [coverage]
  reduct-order              -- forget ≤ on D, keep D and the maps   [reconstructability]
  quotient-function(f, q)  -- f ↦ q ∘ f, for f ∈ {event, attribution}

The conjecture under test: quotient-function is ONE generic operation
parameterized by which function it acts on -- so observability
(quotient event) and traceability (quotient attribution) are the SAME
mechanism-kind, not two independent ones. If true, a single generic
builder, instantiated twice, should reproduce both witnesses with no
dimension-specific code.
"""

from collections import defaultdict
from itertools import permutations


def resolved(worlds, obs, claim):
    """Check if a claim is resolved in the given worlds and observations.

    A claim is considered resolved if, for each distinct observation,
    the claim takes a unique value.
    """
    groups = defaultdict(set)
    for w in worlds:
        groups[obs(w)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


class History:
    """H : Position -> Event, genuinely partial.

    Position order is Python's natural int order, available independently of D.
    """

    def __init__(self, event_map, attribution_map):
        """Initialize the history with the given event and attribution maps.

        Both maps must have the same set of positions as their keys.
        The domain D is the set of positions with both an event and attribution defined.
        """
        # dom(H) = positions with BOTH an event and attribution defined;
        # a position not in either dict simply has no occurrence.
        assert set(event_map) == set(attribution_map)
        self.D = frozenset(event_map)
        self.event = dict(event_map)
        self.attribution = dict(attribution_map)

    def positions_sorted(self):
        """Return the positions in the history, sorted according to Python's natural int order."""
        return tuple(sorted(self.D))

    # --- the three elementary operations, generic over any History ---

    def restrict_domain(self, allowed_positions):
        """Restrict the domain of the history to the allowed positions."""
        d2 = self.D & set(allowed_positions)
        return History(
            {p: self.event[p] for p in d2}, {p: self.attribution[p] for p in d2}
        )

    def quotient_function(self, which, q):
        """Which in {'event', 'attribution'}; q is a function on that field's codomain.

        This is the ONE generic operation both
        observability-blind and traceability-blind instantiate.
        """
        src = getattr(self, which)
        new_field = {p: q(v) for p, v in src.items()}
        if which == "event":
            return History(new_field, dict(self.attribution))
        else:
            return History(dict(self.event), new_field)

    def reduct_order_as_observation(self):
        """Not a new History (order isn't stored IN H to begin with, it's a property of Position).

        This returns what an evaluator
        sees if order is forgotten: the same (position -> event,
        attribution) data, but keyed by an UNORDERED identifier instead
        of position, so relative order cannot be recovered from the
        observation.
        """
        # Represent as a frozenset of (event, attribution) pairs --
        # membership survives, position/order does not.
        return frozenset((self.event[p], self.attribution[p]) for p in self.D)

    def as_observation(self):
        """Full-fidelity observation: sorted (position, event, attribution)."""
        return tuple((p, self.event[p], self.attribution[p]) for p in sorted(self.D))


# --- World space ---
# Positions 0..3. Position 3 is the "coverage" position: present or
# absent from D entirely (genuine partiality, not a NONE sentinel).
# Position 0's event varies over {AT, CL} (observability axis).
# Position 1's attribution varies over {A, B} (traceability axis).
# Positions {0,1,2}'s relative order is fixed by their operator identity
# for the reconstructability test below (kept separate, since order
# needs multiple co-varying positions, not a single flag).

worlds = []
for pos3_present in (True, False):
    for op0 in ("AT", "CL"):
        for actor1 in ("A", "B"):
            event = {0: op0, 1: "BD", 2: "VS"}
            attribution = {0: "A", 1: actor1, 2: "A"}
            if pos3_present:
                event[3] = "AT"
                attribution[3] = "A"
            worlds.append(History(event, attribution))

print(f"{len(worlds)} worlds (coverage/observability/traceability space)")

claim_coverage = lambda h: 3 in h.D
claim_observability = lambda h: h.event[0] == "CL"
claim_traceability = lambda h: h.attribution[1] == "A"

ch_full = lambda h: h.as_observation()
ch_cov_blind = lambda h: h.restrict_domain({0, 1, 2}).as_observation()

# THE key test: both of these call the SAME method, quotient_function,
# differing only in the `which` argument -- no dimension-specific code.
collapse_all = lambda v: "COLLAPSED"
ch_obs_blind = lambda h: (
    h.quotient_function("event", collapse_all).as_observation()
    if False
    else _obs_blind(h)
)


def _obs_blind(h):
    # quotient ONLY position 0's event distinction; positions 1,2,3
    # must stay faithful or this isn't a fair test of "blind to event
    # distinctions at the relevant position" vs "blind to everything".
    q = lambda v: "EVENT" if v in ("AT", "CL") else v
    h2 = h.quotient_function("event", q)
    return h2.as_observation()


def _trace_blind(h):
    q = lambda v: "ACTOR"  # collapse all attribution values uniformly
    h2 = h.quotient_function("attribution", q)
    return h2.as_observation()


ch_trace_blind = _trace_blind

print("\nEach row: does this channel resolve this claim?\n")
channels = {
    "full": ch_full,
    "cov-blind": ch_cov_blind,
    "obs-blind": _obs_blind,
    "trace-blind": ch_trace_blind,
}
claims = {
    "coverage": claim_coverage,
    "observability": claim_observability,
    "traceability": claim_traceability,
}

header = f"{'channel':14s}" + "".join(f"{c:16s}" for c in claims)
print(header)
for cname, ch in channels.items():
    row = f"{cname:14s}"
    for cl in claims.values():
        row += f"{resolved(worlds, ch, cl)!s:16s}"
    print(row)

# --- Reconstructability, separately: genuine order-forgetting via
# reduct_order_as_observation, on a world space where D and the
# functions are fixed and ONLY relative order varies. ---
print("\n--- Reconstructability (order reduct, separate space) ---")
order_worlds = []
for perm in permutations(["VS", "BR", "SH"]):
    event = {i: op for i, op in enumerate(perm)}
    attribution = {i: "A" for i in range(3)}
    order_worlds.append(History(event, attribution))

claim_recon = lambda h: (
    h.positions_sorted().index(next(p for p in h.D if h.event[p] == "VS"))
    < h.positions_sorted().index(next(p for p in h.D if h.event[p] == "SH"))
)

ch_recon_full = lambda h: h.as_observation()
ch_recon_blind = lambda h: h.reduct_order_as_observation()

print(
    "full order preserved, resolves:  ",
    resolved(order_worlds, ch_recon_full, claim_recon),
)
print(
    "order reduct (unordered), resolves:",
    resolved(order_worlds, ch_recon_blind, claim_recon),
)
