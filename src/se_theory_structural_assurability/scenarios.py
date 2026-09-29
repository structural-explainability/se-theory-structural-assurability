"""Independently constructed scenarios.

Each defines its own World dataclass, its own channels, its own claim,
and its own admissibility filters representing
adversarial capability / trust assumptions.

No shared coordinate scheme: field names, counts and meanings
differ across scenarios.
"""

from dataclasses import dataclass

from se_theory_structural_assurability.framework import Channel

# ---------------------------------------------------------------------------
# Scenario 1: Integrity
# ---------------------------------------------------------------------------
# An event either did or did not occur (`actual`). An adversary may tamper
# with the record (`tamper`), and may additionally corrupt the mechanism
# that is meant to detect tampering (`detect_corrupt`) -- but ONLY if that
# capability is admitted by the world space. A structurally separate
# "independent" record exists, whose own compromise is a SEPARATE field
# (`independent_compromised`), gated by its own capability assumption.
#
# Two tamper semantics are tested: invertible (the record is flipped, so it
# still carries information) and lossy (the record is overwritten with a
# fixed cover value, destroying information). This is the case selected to
# test whether "detection resolves tampering" is a general fact or an
# artifact of assuming invertible corruption.


@dataclass(frozen=True)
class IntegrityWorld:
    """World state for the integrity scenario."""

    actual: bool
    tamper: bool
    detect_corrupt: bool
    independent_compromised: bool


record_invertible = Channel(
    "record", ["actual", "tamper"], lambda actual, tamper: actual != tamper
)  # XOR
record_lossy = Channel(
    "record_lossy",
    ["actual", "tamper"],
    lambda actual, tamper: False if tamper else actual,
)
detect_flag = Channel(
    "detect_flag",
    ["tamper", "detect_corrupt"],
    lambda tamper, detect_corrupt: tamper != detect_corrupt,
)
independent_record = Channel(
    "independent_record",
    ["actual", "independent_compromised"],
    lambda actual, independent_compromised: actual != independent_compromised,
)

integrity_claim = lambda w: w.actual

INTEGRITY_DOMAINS = {
    "actual": [False, True],
    "tamper": [False, True],
    "detect_corrupt": [False, True],
    "independent_compromised": [False, True],
}

# Admissibility filters (world-space restrictions = trust assumptions):
cap_none = lambda w: (
    not w.tamper and not w.detect_corrupt and not w.independent_compromised
)
cap_tamper_only = lambda w: not w.detect_corrupt and not w.independent_compromised
cap_full_no_independent_trust = lambda w: (
    not w.independent_compromised
)  # detect_corrupt free, independently trusted
cap_full_unrestricted = lambda w: True  # every field free: nothing is trusted


# ---------------------------------------------------------------------------
# Scenario 2: Independence
# ---------------------------------------------------------------------------
# Two monitors each either honestly report `actual` or, if compromised,
# report a fabricated value. Fabricated values (`f1`, `f2`) are independent
# fields, so a colluding adversary who compromises both is not forced to
# make them agree or disagree -- agreement is possible but not automatic,
# which is what makes a "spoofed agreement" a genuine (not assumed) outcome
# of the enumeration below.


@dataclass(frozen=True)
class IndependenceWorld:
    """World state for the independence scenario."""

    actual: bool
    c1: bool
    c2: bool
    f1: bool
    f2: bool


report1 = Channel(
    "report1", ["actual", "c1", "f1"], lambda actual, c1, f1: f1 if c1 else actual
)
report2 = Channel(
    "report2", ["actual", "c2", "f2"], lambda actual, c2, f2: f2 if c2 else actual
)

independence_claim = lambda w: w.actual

INDEPENDENCE_DOMAINS = {
    "actual": [False, True],
    "c1": [False, True],
    "c2": [False, True],
    "f1": [False, True],
    "f2": [False, True],
}

independent_cap_none = lambda w: not w.c1 and not w.c2
# Structural independence assumption: the two monitors cannot BOTH be
# compromised (at most one faulty), but which one, if either, is unknown.
independent_cap_at_most_one = lambda w: not (w.c1 and w.c2)
# Full collusion: both may be compromised simultaneously, independently.
independent_cap_collude = lambda w: True


# ---------------------------------------------------------------------------
# Scenario 3: Observability
# ---------------------------------------------------------------------------
# A pipeline x -> h1 -> a. The externally visible input and action are
# always observable; the intermediate state h1 is hidden unless an
# additional, legitimate observation mechanism is added. No adversary: this
# is a pure evidence-gap scenario, included as the contrast case.


@dataclass(frozen=True)
class ObservabilityWorld:
    """World state for the observability scenario."""

    x: bool
    h1: bool
    a: bool


base_x = Channel("x", ["x"], lambda x: x)
base_a = Channel("a", ["a"], lambda a: a)
h1_channel = Channel("h1", ["h1"], lambda h1: h1)

observability_claim = lambda w: w.h1

OBSERVABILITY_DOMAINS = {"x": [False], "h1": [False, True], "a": [True]}
