# Adversarial Experiments (Python)

## Purpose

Structural Assurability is a claim-relative theory of the evidentiary
capabilities available to an evaluator under specified conditions.

Its candidate structural properties identify potentially important
differences between evidence-producing systems.
However, a difference in a structural property
does not by itself establish a difference in
evidentiary capability or the ability to resolve a claim.

The Python adversarial experiments investigate these relationships
using small, explicitly constructed finite models.

Their immediate purpose is to challenge proposed distinctions before
formalizing them.
In particular, they examine whether apparent evidence gaps
can be distinguished from assumptions about the reliability,
integrity, or independence of available evidence.

A counterexample can expose an inadequate proposed definition or an
unstated assumption before it becomes part of the formal theory.

These experiments are exploratory.
They do not establish universal properties
of the candidate structural dimensions.

## Method

Each scenario independently defines:

- A finite set of possible worlds.
- A claim whose truth may differ between worlds.
- The admissible worlds under specified assumptions.
- The observation channels available to the evaluator.
- The fields of each world that each channel is permitted to read.

A `Channel` declares which world fields it may access.
Its implementation receives only those fields,
preventing it from reading an undeclared hidden
field or the claim itself.

For a selected set of channels,
the experiment groups admissible worlds
by their combined observations.

The claim is resolved when every group contains worlds
that agree on the claim.

A resolution-failure witness is a pair of admissible worlds that produce
the same combined observation but disagree on the claim.

These definitions mirror the intended roles of the Lean theory's
`claimResolvedBy` and `ResolutionFailureWitness`,
and are not formal proof of equivalence with the Lean theory.

The scenarios vary two mechanisms separately where possible:

- **Channel availability:** what the evaluator can observe.
- **World admissibility:** which possible states and adversarial
  behaviors are excluded by the model's assumptions.

This distinction matters because introducing an observation channel
and assuming that the channel cannot be compromised are different
commitments.

## Experimental Questions

The initial experiments investigate three candidate structural properties.

### Observability

Can additional observable information resolve a claim without changing
the admissible worlds?

This provides a simple reference case for an evidence gap that can be
addressed by extending the observation model.

### Integrity

When is additional evidence sufficient to resolve a claim, and when
does resolution also require assumptions about tampering, detection,
or the trustworthiness of an independent source?

The experiments distinguish invertible tampering from lossy tampering
and examine cases where observation channels can themselves be
compromised.

### Independence

When do multiple reporting channels resolve a claim?

The experiments examine honest reporting, a model permitting at most
one faulty source, and a model permitting full collusion.

They specifically challenge the assumption that agreement between
multiple reports necessarily establishes the underlying fact.

## Initial Results

### 1. Observability: a pure evidence gap

The observability scenario holds the admissible world set fixed.

| Observation channels  | Admissible worlds | Claim resolved |
| --------------------- | ----------------: | -------------- |
| Base `{x, a}`         |                 2 | No             |
| Extended `{x, a, h1}` |                 2 | Yes            |

The extended channel set resolves the claim without restricting
the admissible worlds or introducing a new trust assumption.

This is a constructive example of an observation-model difference
that changes claim resolution.
It does not establish that every observability-profile difference
improves resolution.

### 2. Integrity: observations interact with trust assumptions

The integrity experiments produce several distinct outcomes.

| Case                                                           | Observation channels                   | Claim resolved |
| -------------------------------------------------------------- | -------------------------------------- | -------------- |
| Invertible tampering; tampering permitted                      | `record`                               | No             |
| Invertible tampering; trusted detector                         | `record`, `detect_flag`                | Yes            |
| Independent source available; detector and record insufficient | `record`, `detect_flag`                | No             |
| Independent source available and trusted                       | `record`, `detect_flag`, `independent` | Yes            |
| All channels forgeable                                         | `record`, `detect_flag`, `independent` | No             |
| Lossy tampering                                                | `record_lossy`, `detect_flag`          | No             |

Several distinctions emerge.

**Trusted detection can be sufficient under particular assumptions.**

In the invertible-tampering construction, adding the detection flag
resolves the claim when the modeled detector can be trusted.

**Detection is not sufficient in every tampering model.**

In the lossy-tampering construction, two admissible worlds disagree
on the underlying fact even though their record and detection-flag
observations agree.

The experiment produces a resolution-failure witness with the
combined observation `(False, True)`.

**An independent channel is useful only under applicable assumptions.**

In the construction with an independent source, the record and
detection flag do not resolve the claim. Adding the independent
channel resolves it under the specified trust assumption.

When all channels may be forged, even the combined observation from
all three channels fails to resolve the claim.

A witness exists with observation `(False, False, False)` and
opposite claim truth values.

These results do not establish that every integrity problem requires
an independent channel. They demonstrate that the relationship
between added observations and justified trust assumptions must be
made explicit.

### 3. Independence: agreement is not necessarily resolution

The independence experiments compare different admissible
reporting-failure models.

| Admissibility condition   | Admissible worlds | Claim resolved |
| ------------------------- | ----------------: | -------------- |
| No reporting faults       |                 8 | Yes            |
| At most one faulty source |                24 | No             |
| Full collusion permitted  |                32 | No             |

With two honest reporting channels,
the modeled observations resolve the claim.

When at most one source may be faulty, conflicting reports can leave
the underlying fact ambiguous.

The experiment produces a witness in which the observations are
`(False, True)` but the admissible worlds disagree on the claim.

When full collusion is permitted, the two channels can agree and
still fail to resolve the claim.

A witness has the matching observations `(False, False)` despite
opposite claim truth values.

### Partial-Coverage Measure

Partial coverage measures the fraction of enumerated admissible worlds
for which the observation-based reading rule can issue a definite,
sound verdict.

Worlds are grouped by their combined observations. A group is decided
only when every world in that group agrees on the claim. Otherwise,
the reading rule abstains.

Partial coverage is the number of worlds in decided groups divided
by the total number of enumerated admissible worlds.

In the independence experiments, the resulting values are:

- `1.00`: Every admissible world belongs to a decided group.
- `0.67`: Two-thirds of admissible worlds belong to decided groups.
- `0.00`: No admissible world belongs to a decided group.

This is a finite-model coverage fraction, not a probability,
confidence estimate, or general assurance score.

The central result is that agreement between sources cannot be
interpreted independently of the failure and collusion assumptions
governing those sources.

## Cross-Test: Channel Availability Versus Trust

A separate integrity experiment tests two changes independently:

1. Restrict admissible adversarial behavior without adding an
   observation channel.
2. Add observation channels without restricting the adversarial
   behavior of those channels.

Neither change resolves the claim in the selected construction.

Resolution becomes possible when an appropriate independent channel
is available and the admissible-world assumptions exclude compromise
of that channel.

The result establishes an interaction between channel availability
and trust within this particular finite model.

It does not establish a universal requirement that integrity always
needs both an independent channel and a corresponding trust
assumption. The trusted-detector example provides a different
resolution mechanism under its own stated assumptions.

## Monotonicity Checks

The automated tests also exercise two properties of the finite
claim-resolution model.

Under a fixed admissible world set, adding observation channels
cannot turn a resolved claim into an unresolved claim.

Under a fixed observation model, restricting the admissible worlds
cannot turn a resolved claim into an unresolved claim.

These statements concern claim resolution under the specified models.
They do not establish general monotonicity of
Structural Assurability capability profiles or
of the candidate structural properties.

## Research Value

The experiments provide several kinds of evidence for further
theory development.

**Constructive examples** demonstrate circumstances in which a
proposed structural change affects claim resolution.

**Counterexamples** identify circumstances in which an apparently
useful observation, detector, or additional reporting source does
not resolve a claim.

**Separating tests** vary observation availability and admissibility
assumptions to expose where additional structural commitments are
needed.

Together, these results help formulate more precise questions
about the relationship between structural properties, evidentiary
capabilities, trust assumptions, and claim resolution.

They are particularly relevant to the unfinished treatment of
integrity and independence, which do not yet have
dimension-specific separating constructions in the Lean theory.

## Limitations and Next Steps

All current results concern explicitly constructed finite worlds.
They are not empirical findings about deployed systems.

The experiments do not establish that the candidate properties
are mutually independent, universally necessary, or jointly
sufficient,
nor do they independently establish that any modeled trust
assumption is justified in an operational system.

The next research task is to challenge these constructions with
additional cases, identify which distinctions survive, and
determine whether they support definitions and proof obligations
suitable for Lean formalization.

A surviving experimental result is a candidate for formalization,
not a substitute for a proof.

The experiments may also inform the evaluation of external
assurance frameworks, including questions about whether those
frameworks adequately distinguish available observations from
the assumptions required to rely on them.

Whether this work yields a general theorem, an additional
structural definition, or a useful external research contribution
remains open.

## Implementation

The experimental implementation is under
`src/se_theory_structural_assurability/`:

- `framework.py`: finite-world observation channels, resolution
  evaluation, and resolution-failure witnesses.
- `scenarios.py`: independent adversarial constructions.
- `run_experiment.py`: scenario execution and reporting.
- `test_experiment.py`: regression assertions for established
  experimental outcomes.

### Running the Experiments

```shell
uv run python -m se_theory_structural_assurability.run_experiment
uv run python -m se_theory_structural_assurability.test_experiment
uv run python -m pytest test_experiment.py -q
```

The reported run completed all 15 experiment assertions successfully.

A failing assertion indicates that an experimental result has
changed and that conclusions based on it require re-examination.

## Authority

The Lean source remains authoritative for the formal theory.

The Python experiments are an exploratory research instrument.
Their outcomes do not modify the Lean theory, establish new
public theorems, or discharge the proof obligations of a
dimension-specific separating construction.
