# Approximation Transfer

Approximation transfer establishes conditions under which
claim-resolution results obtained in an abstract model can be
transferred to a concrete model.

The formalization distinguishes two directions:
transferring resolution failures and
transferring positive resolution results.

Each direction requires a different relationship between
abstract and concrete observations.

## Failure Transfer

An abstract resolution failure occurs when two admissible worlds
disagree on a claim but produce identical observations.

`FailureTransfer` provides sufficient conditions for transferring
such a failure to a concrete model.

These conditions include:

- a realization mapping from abstract to concrete worlds;
- preservation of admissibility;
- preservation of claim truth; and
- factorization of concrete observations through abstract observations.

The final condition ensures that two realized worlds
indistinguishable in the abstract model
remain indistinguishable in the concrete model.

Under these assumptions, an abstract resolution-failure witness
produces a concrete resolution-failure witness.

Consequently, abstract unresolvability
implies concrete unresolvability.

## Positive Resolution Transfer

Positive resolution transfer requires the reverse relationship.
`ResolutionTransfer` provides:

- a mapping from concrete worlds to abstract worlds;
- preservation of admissibility;
- preservation of claim truth; and
- factorization of abstract observations through concrete observations.

The observation condition ensures that concrete observational
indistinguishability implies abstract observational
indistinguishability.

Under these assumptions, abstract claim resolution
implies concrete claim resolution.

## Witness-Level Transfer

`WitnessRealization` provides a more localized construction
for transferring resolution failure.

It requires only two concrete worlds realizing one abstract
resolution-failure witness.

The two concrete worlds must be admissible, preserve the
abstract witness's claim truth values, and remain
observationally indistinguishable.

No global mapping between abstract and concrete world spaces
is required.

The formalization proves that every `FailureTransfer`
provides a corresponding `WitnessRealization`.

It has not established that the witness-level condition
is strictly weaker through a separate counterexample.

## Observation Assumptions

The general transfer theorems use observation factorization.

For failure transfer, concrete observations must be determined
by abstract observations on the relevant admissible worlds.

For positive resolution transfer, abstract observations must
be determined by concrete observations on the relevant
admissible worlds.

Factorization is sufficient for the respective transfer
results.
The proofs use the resulting preservation of
observational indistinguishability.

The formalization includes counterexamples showing that
the observation assumptions cannot simply be omitted
from these transfer results.

## Application Boundaries

A formally valid transfer theorem does not establish
that its assumptions hold for an operational system.

Applying a resolution-failure result requires justification
that the relevant concrete worlds are realizable and that
the evaluator cannot distinguish them using observations
outside the modeled evidence surface.

Applying a positive resolution result requires justification
of the relevant concrete-world coverage and observation
relationship.

The precinct-vintage and deployment-shift examples
demonstrate witness-level transfer between specified
finite models.
They do not establish observation faithfulness
for actual operational systems.

## Source of Truth

- [ApproximationTransfer.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/ApproximationTransfer.lean)
- [Bounds.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/Bounds.lean)
