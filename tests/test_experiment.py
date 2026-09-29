"""
Automated tests for the principal results. Run with:
    python3 -m pytest test_experiment.py -q
or plainly:
    python3 test_experiment.py
"""

from se_theory_structural_assurability.framework import (
    Channel,
    enumerate_worlds,
    resolved,
    sound_partial_verdict,
    witnesses,
)
from se_theory_structural_assurability.scenarios import (
    INDEPENDENCE_DOMAINS,
    INTEGRITY_DOMAINS,
    OBSERVABILITY_DOMAINS,
    IndependenceWorld,
    IntegrityWorld,
    ObservabilityWorld,
    base_a,
    base_x,
    cap_full_no_independent_trust,
    cap_full_unrestricted,
    cap_tamper_only,
    detect_flag,
    h1_channel,
    independence_claim,
    independent_cap_at_most_one,
    independent_cap_collude,
    independent_cap_none,
    independent_record,
    integrity_claim,
    observability_claim,
    record_invertible,
    record_lossy,
    report1,
    report2,
)


def test_observability_pure_evidence_gap():
    ws = enumerate_worlds(ObservabilityWorld, OBSERVABILITY_DOMAINS)
    assert not resolved(ws, [base_x, base_a], observability_claim)
    assert resolved(ws, [base_x, base_a, h1_channel], observability_claim)


def test_integrity_invertible_tamper_baseline_unresolved():
    ws = enumerate_worlds(IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_tamper_only)
    assert not resolved(ws, [record_invertible], integrity_claim)


def test_integrity_detection_alone_resolves_when_detector_trusted():
    ws = enumerate_worlds(IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_tamper_only)
    assert resolved(ws, [record_invertible, detect_flag], integrity_claim)


def test_integrity_detection_fails_when_detector_not_trusted():
    ws = enumerate_worlds(
        IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_full_no_independent_trust
    )
    assert not resolved(ws, [record_invertible, detect_flag], integrity_claim)


def test_integrity_independent_channel_resolves_under_trust_assumption():
    """Additional independent evidence resolves the claim, given an existing
    trust assumption (the independent channel itself is not compromised)."""
    ws = enumerate_worlds(
        IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_full_no_independent_trust
    )
    assert resolved(
        ws, [record_invertible, detect_flag, independent_record], integrity_claim
    )


def test_integrity_unresolvable_when_every_channel_forgeable():
    """No additional evidence helps once every channel, including the
    'independent' one, can be forged by the adversary."""
    ws = enumerate_worlds(
        IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_full_unrestricted
    )
    assert not resolved(
        ws, [record_invertible, detect_flag, independent_record], integrity_claim
    )


def test_integrity_lossy_tamper_defeats_detection():
    """Falsification check: detection does NOT generically suffice; it
    depends on the tamper mechanism preserving information (invertibility)."""
    ws = enumerate_worlds(IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_tamper_only)
    assert not resolved(ws, [record_lossy, detect_flag], integrity_claim)


def test_independence_two_honest_channels_resolve():
    ws = enumerate_worlds(
        IndependenceWorld, INDEPENDENCE_DOMAINS, admissible=independent_cap_none
    )
    assert resolved(ws, [report1, report2], independence_claim)


def test_independence_at_most_one_faulty_does_not_fully_resolve():
    """Even the standard 'at most one compromised' independence assumption
    does not achieve full resolution with only two witnesses: disagreement
    is genuinely ambiguous (can't tell which one is lying)."""
    ws = enumerate_worlds(
        IndependenceWorld, INDEPENDENCE_DOMAINS, admissible=independent_cap_at_most_one
    )
    assert not resolved(ws, [report1, report2], independence_claim)


def test_independence_at_most_one_faulty_gives_sound_partial_coverage():
    """But it does give a sound, non-trivial partial reading rule: trust the
    claim when the two reports agree, abstain when they disagree."""
    ws = enumerate_worlds(
        IndependenceWorld, INDEPENDENCE_DOMAINS, admissible=independent_cap_at_most_one
    )
    coverage, sound, _ = sound_partial_verdict(
        ws, [report1, report2], independence_claim
    )
    assert sound
    assert 0.0 < coverage < 1.0


def test_independence_full_collusion_spoofs_agreement():
    """Under full collusion, even the 'reports agree' rule is unsound: there
    exist admissible worlds where both channels agree and the claim differs."""
    ws = enumerate_worlds(
        IndependenceWorld, INDEPENDENCE_DOMAINS, admissible=independent_cap_collude
    )
    w = witnesses(ws, [report1, report2], independence_claim)
    agreeing_witnesses = [(obs, a, b) for obs, a, b in w if obs[0] == obs[1]]
    assert agreeing_witnesses, (
        "expected a witness pair where both channels agree but claim differs"
    )


def test_restriction_alone_does_not_resolve_integrity():
    """Restricting the world space without widening the observation model
    does not resolve the integrity claim (channel set held at {record})."""
    ws = enumerate_worlds(IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_tamper_only)
    assert not resolved(ws, [record_invertible], integrity_claim)


def test_widening_alone_does_not_resolve_integrity_without_trust():
    """Widening channels without restricting admissibility (no trust
    assumption on any channel) does not resolve the integrity claim."""
    ws = enumerate_worlds(
        IntegrityWorld, INTEGRITY_DOMAINS, admissible=cap_full_unrestricted
    )
    assert not resolved(
        ws, [record_invertible, detect_flag, independent_record], integrity_claim
    )


def test_candidate_monotonicity_more_channels_never_hurts():
    """Candidate theorem check: resolved(channels) implies resolved(channels
    + extra), for a fixed admissible world space. Brute-forced over random
    small worlds, not just the three scenarios."""
    from dataclasses import make_dataclass
    import random

    random.seed(0)
    for _ in range(200):
        n_fields = random.randint(2, 4)
        fields = [f"f{i}" for i in range(n_fields)]
        W = make_dataclass("RandWorld", fields)
        domains = {f: [False, True] for f in fields}
        ws = enumerate_worlds(W, domains)
        claim_field = random.choice(fields)

        def claim(w, k=claim_field):
            return getattr(w, k)

        base_fields = random.sample(fields, random.randint(0, n_fields - 1))
        extra_fields = [f for f in fields if f not in base_fields]
        base_channels = [Channel(f, [f], lambda v: v) for f in base_fields]
        all_channels = base_channels + [
            Channel(f, [f], lambda v: v) for f in extra_fields
        ]
        if resolved(ws, base_channels, claim):
            assert resolved(ws, all_channels, claim)


def test_candidate_monotonicity_shrinking_admissible_worlds_never_hurts():
    """Candidate theorem check: resolved over a world space S implies
    resolved over any admissible-subset S' of S, for a fixed channel set."""
    from dataclasses import make_dataclass
    import random

    random.seed(1)
    for _ in range(200):
        n_fields = random.randint(2, 4)
        fields = [f"f{i}" for i in range(n_fields)]
        W = make_dataclass("RandWorld2", fields)
        domains = {f: [False, True] for f in fields}
        ws_full = enumerate_worlds(W, domains)
        claim_field = random.choice(fields)

        def claim(w, k=claim_field):
            return getattr(w, k)

        n_channels = random.randint(0, n_fields)
        chosen = random.sample(fields, n_channels)
        channels = [Channel(f, [f], lambda v: v) for f in chosen]
        if resolved(ws_full, channels, claim):
            keep_prob = random.random()
            ws_sub = [w for w in ws_full if random.random() < keep_prob or True]
            # genuine subset, not just a relabeling
            ws_sub = random.sample(ws_full, k=random.randint(0, len(ws_full)))
            assert resolved(ws_sub, channels, claim)


if __name__ == "__main__":
    import sys

    tests = [v for k, v in list(globals().items()) if k.startswith("test_")]
    failed = 0
    for t in tests:
        try:
            t()
            print(f"PASS  {t.__name__}")
        except AssertionError as e:
            failed += 1
            print(f"FAIL  {t.__name__}: {e}")
    print(f"\n{len(tests) - failed}/{len(tests)} passed")
    sys.exit(1 if failed else 0)
