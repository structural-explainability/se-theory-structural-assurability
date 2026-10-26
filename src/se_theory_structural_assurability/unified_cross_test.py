"""One unified World space, one unified set of channels, four claims: a proper cross-test.

Does dimension X's own fix (and only that fix)
resolve claim X, while leaving claims Y, Z, W unresolved unless their
own specific fix is also applied?

If the four are genuinely independent failure mechanisms, each fix
should resolve exactly its own claim and no other, when applied alone.
"""

from collections import defaultdict


def resolved(worlds, obs, claim):
    """Check if a claim is resolved in the given worlds and observations."""
    groups = defaultdict(set)
    for w in worlds:
        groups[obs(w)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


# World: a fixed-length 3-slot history. Each slot is (operator, actor).
# Slot 0 is always AT/A (fixed, for orientation). Slots 1 and 2 vary:
#   slot 1: operator in {AT, CL}   -- tests observability (family)
#           AND actor in {A, B}     -- tests traceability (who)
#   slot 2: operator in {VS, SH}   -- position matters for reconstructability
# Coverage is tested separately via an access-window parameter, since it
# is about WHICH slots are visible, not what varies within a slot.
ops1 = ["AT", "CL"]
actors1 = ["A", "B"]
ops2 = ["VS", "SH"]
# Coverage axis: whether an event occurs at slot 3 at all, vs. no event
# (represented as a fourth, fixed-position slot with two possibilities:
# an AT event present, or nothing -- modeled as a placeholder "NONE"
# event that a full-access channel still reports faithfully). This is a
# distinct axis of variation from all three above: it is not what a slot
# contains, but whether a slot beyond the accessible window holds
# anything the claim cares about.
slot3_variants = [("AT", "A"), ("NONE", "-")]

worlds = [
    ((("AT", "A"), (op1, actor1), (op2, "A"), slot3))
    for op1 in ops1
    for actor1 in actors1
    for op2 in ops2
    for slot3 in slot3_variants
]

# --- Claims, one per dimension, each depending on exactly one axis of variation ---
claim_observability = lambda w: (
    w[1][0] == "CL"
)  # did a scaling-family event occur at slot 1?
claim_traceability = lambda w: w[1][1] == "A"  # did actor A perform slot 1's event?
claim_reconstructability = lambda w: (
    w[2][0] == "VS"
)  # was slot 2's event specifically VS (vs SH)?
claim_coverage = lambda w: w[3][0] == "AT"  # did an event occur at slot 3 at all?

# --- Channels ---
# Full channel: everything visible.
ch_full = lambda w: w

# Observability-blind: slot 1's operator collapses AT/CL to the same
# token (schema can't represent the scaling family); everything else,
# including slot 3, still reported normally.
ch_obs_blind = lambda w: (w[0], ("EVENT", w[1][1]), w[2], w[3])

# Traceability-blind: actor dropped from every slot; operators still
# reported normally (including whether slot 3 holds an event at all).
ch_trace_blind = lambda w: tuple((e[0],) for e in w)

# Reconstructability-blind: slot 2's operator reported as an
# order/identity-blind category -- VS and SH both map to "TEMPORAL_OP".
# Everything else, including slot 3, reported normally.
ch_recon_blind = lambda w: (w[0], w[1], ("TEMPORAL_OP", w[2][1]), w[3])

# Coverage-blind: the access WINDOW does not extend to slot 3 at all --
# not a collapsed value at a known position, but the position itself
# absent from what the channel returns. Distinct mechanism from all
# three above, matching the earlier separately-tested coverage scenario.
ch_cov_blind = lambda w: w[:3]

print("Each row: does this channel resolve this claim?\n")
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

print("\nExpected, if the four are genuinely independent:")
print("  full          resolves all three")
print("  obs-blind     fails ONLY observability's claim")
print("  trace-blind   fails ONLY traceability's claim")
print("  recon-blind   fails ONLY reconstructability's claim")
