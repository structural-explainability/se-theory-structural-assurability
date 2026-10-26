"""History dimensions test.

Does giving `World` real structure -- a referent plus a transformation
history built from se-theory-transformation's actual operator registry --
make observability, coverage, traceability, and reconstructability
structurally distinct, where the earlier finite models (built as "reveal
another hidden boolean field", four times) made them collapse?

Each of the four gets its OWN channel-failure mechanism, chosen to match
what it actually means, not a relabeled copy of the others:

  observability     -- the channel's schema doesn't cover a whole operator
                        FAMILY. Two histories differing only in whether a
                        CL (collapse) event occurred are indistinguishable
                        if nothing in the channel schema reports on the
                        scaling family at all.
  coverage          -- the channel's schema DOES cover the family, but
                        access is restricted to a scope/window. An event
                        outside that window is invisible even though the
                        channel type supports it -- structurally different
                        from observability's blindness.
  traceability      -- the log reports operator TYPES but not the ACTOR
                        who performed each one. Two histories differing
                        only in who performed a step are indistinguishable.
  reconstructability -- the evidence is a compressed final-state
                        PROJECTION (a la operator PR), not the event
                        sequence. Two DIFFERENT ORDERINGS of the same
                        operator multiset, producing the same final state,
                        are indistinguishable.

If these four mechanisms are genuinely different, resolving one claim's
witness should not automatically resolve another dimension's claim, and
the cross-test (does dimension X's own fix accidentally also fix
dimension Y's claim) should mostly come back negative.
"""

from collections import defaultdict
from itertools import permutations


def resolved(worlds, obs, claim):
    """Check if a claim is resolved in the given worlds and observations."""
    groups = defaultdict(set)
    for w in worlds:
        groups[obs(w)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


def witnesses(worlds, obs, claim):
    """Return a list of witness tuples (observation, world_a, world_b) where the claim is disputed."""
    groups = defaultdict(list)
    for w in worlds:
        groups[obs(w)].append(w)
    out = []
    for o, ws in groups.items():
        vals = {claim(w) for w in ws}
        if len(vals) > 1:
            a = next(w for w in ws if claim(w))
            b = next(w for w in ws if not claim(w))
            out.append((o, a, b))
    return out


# An Event is (operator_code, actor). A World's history is a tuple of
# Events. Operator codes are drawn from se-theory-transformation's real
# registry: AT (attest), BD (bind), CL (collapse), VS (version),
# BR (branch), SH (shift).

# ---------------------------------------------------------------------
# OBSERVABILITY: does the channel's schema cover the CL family at all?
# ---------------------------------------------------------------------
# World: a 2-event history. Second event is either CL (scaling family) or
# AT (attestation family) -- same actor, same position, different family.
obs_worlds = [
    (("AT", "A"), ("CL", "A")),
    (("AT", "A"), ("AT", "A")),
]
# Claim: "a scaling-family (CL) event occurred"
obs_claim = lambda w: w[1][0] == "CL"

# Channel with NO coverage of the scaling family at all: for a schema
# that cannot represent the scaling family, ANY operator occupying a
# position that could be scaling-or-not must map to the SAME token --
# not a distinct "unschematized" label, which would itself leak the
# distinction (label the true value, just differently). This is the
# second attempt at this channel; the first attempt made exactly that
# mistake.
obs_channel_blind = lambda w: tuple(
    "EVENT" if e[0] in ("AT", "CL") else e[0] for e in w
)
# Channel that DOES include scaling-family events in its schema:
obs_channel_full = lambda w: w

print("== OBSERVABILITY ==")
print(
    "  blind to CL family, resolves:",
    resolved(obs_worlds, obs_channel_blind, obs_claim),
)
print(
    "  full schema, resolves:       ", resolved(obs_worlds, obs_channel_full, obs_claim)
)

# ---------------------------------------------------------------------
# COVERAGE: schema covers CL, but access is windowed to timestep 0 only.
# ---------------------------------------------------------------------
# World: a 2-event history (index 0, index 1). CL may occur at either
# index; claim is about whether CL occurred ANYWHERE in the history.
cov_worlds = [
    (("AT", "A"), ("AT", "A")),
    (("CL", "A"), ("AT", "A")),  # CL at index 0 -- inside the window
    (("AT", "A"), ("CL", "A")),  # CL at index 1 -- outside the window
]
cov_claim = lambda w: any(e[0] == "CL" for e in w)

# Windowed channel: schema covers CL, but only reports index 0.
cov_channel_windowed = lambda w: (w[0],)
# Full-timeline channel: reports every index.
cov_channel_full = lambda w: w

print("\n== COVERAGE ==")
print(
    "  windowed to index 0, resolves:",
    resolved(cov_worlds, cov_channel_windowed, cov_claim),
)
print(
    "  full timeline, resolves:      ",
    resolved(cov_worlds, cov_channel_full, cov_claim),
)
w = witnesses(cov_worlds, cov_channel_windowed, cov_claim)
if w:
    print("  witness (CL outside the window is invisible):", w[0][1], "vs", w[0][2])

# ---------------------------------------------------------------------
# TRACEABILITY: log reports operator TYPE but not ACTOR.
# ---------------------------------------------------------------------
# World: a 1-event history at a BD (bind) step, actor varies.
trace_worlds = [
    (("BD", "A"),),
    (("BD", "B"),),
]
trace_claim = lambda w: w[0][1] == "A"  # "actor A performed the bind"

# Type-only channel: reports operator code, drops actor.
trace_channel_type_only = lambda w: tuple(e[0] for e in w)
# Type+actor channel: reports both.
trace_channel_full = lambda w: w

print("\n== TRACEABILITY ==")
print(
    "  type-only log, resolves:",
    resolved(trace_worlds, trace_channel_type_only, trace_claim),
)
print(
    "  type+actor log, resolves:",
    resolved(trace_worlds, trace_channel_full, trace_claim),
)
w = witnesses(trace_worlds, trace_channel_type_only, trace_claim)
if w:
    print("  witness (same type, different actor):", w[0][1], "vs", w[0][2])

# ---------------------------------------------------------------------
# RECONSTRUCTABILITY: evidence is a compressed final-state PROJECTION,
# not the event sequence -- can the evaluator recover ORDER?
# ---------------------------------------------------------------------
# World: a 3-event history using VS, BR, SH in some order. "Final state"
# is modeled as the multiset of operator types actually applied (what a
# naive end-state projection would show: what happened, not in what
# order) -- deliberately losing sequence information a full log keeps.
recon_worlds = list(permutations(["VS", "BR", "SH"]))
# Claim: "VS occurred before SH" -- an order-dependent fact.
recon_claim = lambda w: w.index("VS") < w.index("SH")

# Projection channel: reports only the multiset (order-blind).
recon_channel_projection = lambda w: tuple(sorted(w))
# Full-log channel: reports the actual sequence.
recon_channel_full = lambda w: w

print("\n== RECONSTRUCTABILITY ==")
print(
    "  end-state projection, resolves:",
    resolved(recon_worlds, recon_channel_projection, recon_claim),
)
print(
    "  full event log, resolves:      ",
    resolved(recon_worlds, recon_channel_full, recon_claim),
)
w = witnesses(recon_worlds, recon_channel_projection, recon_claim)
if w:
    print("  witness (same multiset, different order):", w[0][1], "vs", w[0][2])

# ---------------------------------------------------------------------
# CROSS-TEST: does each dimension's OWN fix accidentally also resolve
# the OTHER three dimensions' claims? (Genuine independence check.)
# ---------------------------------------------------------------------
print("\n== CROSS-TEST: does dimension X's fix resolve dimension Y's claim? ==")
print("(only meaningful where the world/claim pairs could share a channel;")
print(" traceability and reconstructability use incompatible World shapes")
print(" from observability/coverage, so those pairs are structurally N/A)")

# observability's fix (full schema) applied to coverage's world/claim,
# restricted to what observability's channel shape can even express:
cov_via_obs_fix = lambda w: w  # same as cov_channel_full structurally
print(
    "  observability's fix resolves coverage's claim:",
    resolved(cov_worlds, cov_via_obs_fix, cov_claim),
    "(expected True: a full-schema, full-access channel is strictly ",
)
print("    stronger than either individual fix -- this is NOT evidence")
print("    the two mechanisms are the same, only that the strongest")
print("    channel dominates both, which is the monotonicity result")
print("    from earlier in this conversation, not a new collapse)")
