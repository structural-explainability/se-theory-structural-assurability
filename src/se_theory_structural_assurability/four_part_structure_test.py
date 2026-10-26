"""Four part structure test.

Corrected four-way test, built directly against the proposed structure:

    history = ordered positions
              + accessibility at each position
              + operator/event value at each position
              + metadata attached to each occurrence

  coverage           -- accessibility axis: is a position in the domain at all
  observability      -- value axis: which operator occurred at a position
  traceability       -- metadata axis: attribution attached to an occurrence
  reconstructability -- order axis: relative sequence among MULTIPLE positions

The previous unified test's "reconstructability" channel collapsed a
single slot's value -- the same mechanism as observability, not an order
mechanism. This rebuild gives reconstructability its own genuine axis:
three positions whose relative order varies independently of what
operators occupy them.
"""

from collections import defaultdict
from itertools import permutations


def resolved(worlds, obs, claim):
    """Check if a claim is resolved in the given worlds and observations."""
    groups = defaultdict(set)
    for w in worlds:
        groups[obs(w)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


# World = (order_slots, value_slot, meta_slot, access_slot)
#   order_slots: a permutation of (VS, BR, SH) across positions 0,1,2 --
#     the ONLY thing varying here is relative order; actor fixed "A".
#   value_slot:  operator in {AT, CL}, actor fixed "A" -- observability.
#   meta_slot:   operator fixed "BD", actor in {A, B} -- traceability.
#   access_slot: event present (AT, A) or absent (NONE, -) -- coverage.

order_perms = list(permutations(["VS", "BR", "SH"]))
value_ops = ["AT", "CL"]
meta_actors = ["A", "B"]
access_variants = [("AT", "A"), ("NONE", "-")]

worlds = [
    (perm, (vop, "A"), ("BD", mact), avar)
    for perm in order_perms
    for vop in value_ops
    for mact in meta_actors
    for avar in access_variants
]
print(f"{len(worlds)} worlds")

# --- Claims, each depending on exactly one axis ---
claim_reconstructability = lambda w: (
    w[0].index("VS") < w[0].index("SH")
)  # order-dependent
claim_observability = lambda w: w[1][0] == "CL"  # value-dependent
claim_traceability = lambda w: w[2][1] == "A"  # metadata-dependent
claim_coverage = lambda w: w[3][0] == "AT"  # access-dependent

# --- Channels ---
ch_full = lambda w: w

# recon-blind: order slots reported as a SORTED tuple (multiset), losing
# relative order entirely. Everything else passed through unchanged.
ch_recon_blind = lambda w: (tuple(sorted(w[0])), w[1], w[2], w[3])

# obs-blind: value slot's operator collapses AT/CL to the same token.
# Order and everything else passed through unchanged.
ch_obs_blind = lambda w: (w[0], ("EVENT", w[1][1]), w[2], w[3])

# trace-blind: actor stripped from the meta slot (and, for honesty,
# from the order and value slots too, though nothing there depends on
# it) -- operator identity kept everywhere.
ch_trace_blind = lambda w: (w[0], (w[1][0],), (w[2][0],), w[3])

# cov-blind: access slot truncated from the output entirely -- a fixed
# prefix, so length carries no information regardless of content.
ch_cov_blind = lambda w: w[:3]

print("\nEach row: does this channel resolve this claim?\n")
channels = {
    "full": ch_full,
    "obs-blind": ch_obs_blind,
    "cov-blind": ch_cov_blind,
    "trace-blind": ch_trace_blind,
    "recon-blind": ch_recon_blind,
}
claims = {
    "observability": claim_observability,
    "coverage": claim_coverage,
    "traceability": claim_traceability,
    "reconstructability": claim_reconstructability,
}

header = f"{'channel':14s}" + "".join(f"{c:22s}" for c in claims)
print(header)
for cname, ch in channels.items():
    row = f"{cname:14s}"
    for cl in claims.values():
        row += f"{resolved(worlds, ch, cl)!s:22s}"
    print(row)
