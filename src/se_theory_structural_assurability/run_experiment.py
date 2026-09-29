"""Run experiments for structural assurability scenarios."""

from se_theory_structural_assurability.framework import (
    enumerate_worlds,
    resolved,
    sound_partial_verdict,
    witnesses,
)
from se_theory_structural_assurability.scenarios import *

print("=" * 70)
print("SCENARIO 1: INTEGRITY")
print("=" * 70)


def show_integrity(record_channel, record_name, cap, cap_name, channels, chnames):
    """Show the integrity status for a given set of channels and capability."""
    ws = enumerate_worlds(IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap)
    r = resolved(ws, channels, integrity_claim)
    print(
        f"  [{record_name:18s}] cap={cap_name:22s} channels={chnames:35s} "
        f"|worlds|={len(ws):2d} resolved={r}"
    )
    return ws, r


print("-- invertible tamper --")
show_integrity(
    record_invertible, "invertible", cap_none, "none", [record_invertible], "{record}"
)
show_integrity(
    record_invertible,
    "invertible",
    cap_tamper_only,
    "tamper_only",
    [record_invertible],
    "{record}",
)
show_integrity(
    record_invertible,
    "invertible",
    cap_tamper_only,
    "tamper_only",
    [record_invertible, detect_flag],
    "{record,detect_flag}",
)
show_integrity(
    record_invertible,
    "invertible",
    cap_full_no_independent_trust,
    "full,independent_trusted",
    [record_invertible, detect_flag],
    "{record,detect_flag}",
)
ws, r = show_integrity(
    record_invertible,
    "invertible",
    cap_full_no_independent_trust,
    "full,independent_trusted",
    [record_invertible, detect_flag, independent_record],
    "{record,detect_flag,independent}",
)
assert r, (
    "expected: independent channel + trust assumption resolves under full local capability"
)
ws, r = show_integrity(
    record_invertible,
    "invertible",
    cap_full_unrestricted,
    "full,NO trust anywhere",
    [record_invertible, detect_flag, independent_record],
    "{record,detect_flag,independent}",
)
assert not r, "expected: no channel resolves when every mechanism is forgeable"
w = witnesses(ws, [record_invertible, detect_flag, independent_record], integrity_claim)
print(
    f"    witness under total forgeability: obs={w[0][0]}  actual={w[0][1].actual} vs {w[0][2].actual}"
)

print("-- lossy tamper (falsification check) --")
show_integrity(
    record_lossy,
    "lossy",
    cap_tamper_only,
    "tamper_only",
    [record_lossy],
    "{record_lossy}",
)
ws, r = show_integrity(
    record_lossy,
    "lossy",
    cap_tamper_only,
    "tamper_only",
    [record_lossy, detect_flag],
    "{record_lossy,detect_flag}",
)
assert not r, "FALSIFIED naive claim: detection does not suffice for lossy tampering"
w = witnesses(ws, [record_lossy, detect_flag], integrity_claim)
print(
    f"    witness (detection present, still unresolved): obs={w[0][0]} "
    f"actual={w[0][1].actual} vs {w[0][2].actual}"
)

print()
print("=" * 70)
print("SCENARIO 2: INDEPENDENCE")
print("=" * 70)


def show_independence(cap, cap_name, channels, chnames):
    """Show the independence status for a given set of channels and capability."""
    ws = enumerate_worlds(IndependenceWorld, INDEPENDENCE_DOMAINS, admissible=cap)
    r = resolved(ws, channels, independence_claim)
    cov, _sound, _ = sound_partial_verdict(ws, channels, independence_claim)
    print(
        f"  cap={cap_name:22s} channels={chnames:20s} |worlds|={len(ws):3d} "
        f"resolved={r!s:5s} partial-coverage={cov:.2f}"
    )
    return ws, r, cov


show_independence(independent_cap_none, "none", [report1, report2], "{report1,report2}")

ws, r, cov = show_independence(
    independent_cap_at_most_one,
    "at_most_one_faulty",
    [report1, report2],
    "{report1,report2}",
)
assert not r, "expected: full resolution fails even under 'at most one faulty'"
assert cov < 1.0, "expected: sound-abstaining coverage is strictly partial"
w = witnesses(ws, [report1, report2], independence_claim)
print(
    f"    disagreement-ambiguity witness: obs={w[0][0]} actual={w[0][1].actual} vs {w[0][2].actual}"
)

ws, r, cov = show_independence(
    independent_cap_collude, "full_collusion", [report1, report2], "{report1,report2}"
)
assert not r
w = witnesses(ws, [report1, report2], independence_claim)
spoofed_agree = [(obs, a, b) for obs, a, b in w if obs[0] == obs[1]]
assert spoofed_agree, "expected: under full collusion, agreement itself is spoofable"
obs, a, b = spoofed_agree[0]
print(
    f"    SPOOFED-AGREEMENT witness (both channels agree, claim differs): "
    f"obs={obs} actual={a.actual} vs {b.actual}"
)

print()
print("=" * 70)
print("SCENARIO 3: OBSERVABILITY")
print("=" * 70)

ws = enumerate_worlds(ObservabilityWorld, OBSERVABILITY_DOMAINS)
r_base = resolved(ws, [base_x, base_a], observability_claim)
r_wide = resolved(ws, [base_x, base_a, h1_channel], observability_claim)
print(f"  base {{x,a}}         |worlds|={len(ws)} resolved={r_base}")
print(f"  widened {{x,a,h1}}   |worlds|={len(ws)} resolved={r_wide}")
assert not r_base and r_wide
print(
    "  -> pure evidence gap: resolved by adding a channel, world space untouched, no adversary needed"
)

print()
print("=" * 70)
print("CROSS-TEST: does world-space restriction ALONE (no new channel) ever help")
print("integrity/independence, and does channel-widening ALONE (unrestricted world")
print("space) ever help, WITHOUT smuggling in the ground-truth field directly?")
print("=" * 70)

ws_restricted_only = enumerate_worlds(
    IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_tamper_only
)
r = resolved(ws_restricted_only, [record_invertible], integrity_claim)
print(
    f"  integrity: restrict-only (cap_tamper_only), channels={{record}} only: resolved={r}"
)
assert not r, (
    "restricting admissibility WITHOUT widening channels does not resolve integrity"
)

ws_unrestricted = enumerate_worlds(
    IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_full_unrestricted
)
r = resolved(
    ws_unrestricted,
    [record_invertible, detect_flag, independent_record],
    integrity_claim,
)
print(
    f"  integrity: widen-only (unrestricted world space), channels={{record,detect_flag,independent}}: "
    f"resolved={r}"
)
assert not r, (
    "widening channels WITHOUT restricting admissibility does not resolve integrity"
)

print()
print("  => resolving integrity here needs BOTH a channel (independent_record) AND")
print(
    "     a trust assumption on that same channel (independent_compromised excluded)."
)
print("     Neither mechanism alone suffices: they interact within one construction.")

print()
print("ALL ASSERTIONS PASSED")
