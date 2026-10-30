# Research Doubts and Open Questions

This document records the current research assessment,
known limitations, unresolved questions, and safeguards
against overclaiming for this theory.

For the three research criteria, doubt classifications,
status definitions, and procedures, see the
[SE Research Doubts Standard](https://raw.githubusercontent.com/structural-explainability/.github/refs/heads/main/docs/en/research/doubts.md).

## Repository Summary

This assessment is a summary of the present evidence.

| Criterion | Current assessment |
| --------- | ------------------ |
| Mathematical Correctness | Formal results are established under stated hypotheses. Dimension-specific separating constructions exist for observability, evidence coverage, traceability, and reconstructability. Independence, integrity, and controllability do not yet have them. |
| Scientific Adequacy      | Partially established. The candidate set of structural properties is provisional. Applying a resolution-failure result to a system requires justifying that the modeled worlds are realizable and the observations faithful. |
| Theoretical Contribution | The proposed contribution is a claim-relative, context-relative account of evidentiary capability, represented as sets of capabilities rather than a scalar score. No related-work discussion is recorded in this repository. |

The doubts below identify specific issues affecting these assessments.

---

<!-- markdownlint-disable MD024 -->

## Register 1. Doubts About Assumptions (Undermining Doubts)

These questions concern the premises of an argument.
Even if a theorem is correctly proved, can we establish the assumptions necessary to apply it?

### UM-001. (OPEN) Provisional Property Set

#### Research criterion

Scientific Adequacy

#### Concern

Are observability, controllability, traceability, reconstructability, independence, integrity, and evidence coverage the right properties?

#### Current Knowledge

The candidate set is provisional.
The theory does not assume the properties are complete, independent, universally necessary, jointly sufficient, or universally monotone in assurability.
Contribution is established through separating constructions.

See [DECISIONS.md](DECISIONS.md#structural-properties).

#### Remaining Work

Further separating constructions and evidence for or against each property.

### UM-002. (OPEN) Independence, Integrity, and Controllability

#### Research criterion

Mathematical Correctness

#### Concern

Three candidate properties have no dimension-specific construction.

#### Current Knowledge

For independence and integrity, establishing the assurance significance of a profile difference requires additional assumptions about evidence provenance, admissibility, and trust.
For controllability, the current claim-resolution model does not represent how the evaluator's observations depend on permitted interventions and resource constraints.

The Python finite-model experiments are candidates for formalization, not proofs.

#### Remaining Work

Represent those assumptions and interactions, then state the constructions.

### UM-003. (OPEN) Realizability and Observation Faithfulness

#### Research criterion

Scientific Adequacy

#### Concern

A resolution-failure result applies to a system only if the modeled worlds and observations match it.

#### Current Knowledge

The approximation-transfer theorems give conditions for transferring claim-resolution results between abstract and concrete models.
Applying a result to an operational system requires independent justification that the relevant worlds are realizable and that the modeled observations faithfully represent what the evaluator can observe.

Global failure transfer supplies a witness-level realization.
It has not been formally established that the witness-level condition is strictly weaker.

#### Remaining Work

Justification per application, and the strictness question above.

## Register 2. Doubts About Conclusions (Rebutting Doubts)

These questions concern whether a claimed conclusion is false.
For example, a counterexample satisfying all the premises
but violating the conclusion would challenge the claimed theorem or its formalization.
A model that violates a required assumption does not
necessarily refute a conditional theorem.
If a counterexample is found,
we must identify the exact claim it challenges and
whether its assumptions are satisfied.

**None currently identified.**

## Register 3. Doubts About What Our Results Mean (Undercutting Doubts)

These questions concern the connection
between a formal theorem and the scientific claim made about it.
A theorem may be correct while its informal interpretation is too strong.
Some of these doubts are addressed by permanent documentation
rules rather than additional proofs.

### UC-001. (STANDING RULES) Property Differences, Capability Differences, and Claim Resolution

#### Research criterion

Scientific Adequacy

#### Concern

A reader might read a structural-property difference as a difference in assurability, or in claim resolution.

#### Current Knowledge

None of the four dimension-specific constructions establishes a difference in `AssurabilityModel.profile` or in claim resolution.
`notEquivalent` remains a caller-supplied obligation in each.
A traceability-profile difference does not establish that the attributed origin, actor, event, or relationship is authentic.
A reconstructability-profile difference does not establish that the underlying records are authentic, complete, unaltered, or sufficient.

#### Standing Rules

1. Treat structural-property difference, capability-profile non-equivalence, and claim resolution as separate obligations.
2. Do not read traceability or reconstructability differences as establishing authenticity or integrity.

### UC-002. (STANDING RULES) Generic Separating Construction

#### Research criterion

Scientific Adequacy

#### Concern

The generic `SeparatingConstruction` permits any caller-supplied difference relation.

#### Current Knowledge

Its unrestricted use does not establish that a difference belongs to the declared structural dimension.
The dimension-specific constructions prove they can only witness their own dimension.

See [DECISIONS.md](DECISIONS.md#dimension-specific-separating-constructions).

#### Standing Rules

1. Use a dimension-specific construction when attributing a difference to a dimension.

### UC-003. (STANDING RULES) Examples and Experiments

#### Research criterion

Scientific Adequacy

#### Concern

A reader might read the examples as ranking architectures, or experiment results as theorems.

#### Current Knowledge

The examples do not establish a general ranking of architectures.
The Python experiments are not part of the Lean theory.
A result that survives there is a candidate for formalization, not a proof.

See [DECISIONS.md](DECISIONS.md#examples).

#### Standing Rules

1. Do not cite the examples as ranking architectures.
2. Treat experiment results as candidates for formalization.

<!-- markdownlint-enable MD024 -->
