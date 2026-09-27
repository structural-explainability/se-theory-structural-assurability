# Privileged Evaluation

Greater evaluator access does not necessarily produce a universal ordering of
systems.

One architecture may expose detailed internal execution evidence.

Another may expose less internal state while providing independently generated
evidence about consequential external actions.

These structures support different assurance-relevant capabilities.

For example:

- internal visibility may support examination of internal process
- independent observation may support stronger external attribution

Neither capability is automatically more valuable for every claim.

## Example Result

In the formal example, each architecture provides a relevant capability absent
from the other.

Neither capability profile contains the other.

Therefore:

```text
S_V ∥q S_N
```

The architectures are incomparable for the modeled assurance context.

This is one reason Structural Assurability uses **capability profiles**
rather than a universal scalar score.

A system can provide more assurance-relevant evidence
along one dimension and less along another.

## Evaluator Context

The example also illustrates why evaluator access should not be treated as a
single quantity.

Internal visibility, independent observation, evidence integrity, and
corroboration can contribute differently depending on the claim and evaluation
conditions.
Changing the claim or evaluator context may change the comparison.

## Source of Truth

The Lean source is authoritative:

- [`Case3_Incomparability.lean`](../../../SE/StructuralAssurability/Layer90_Examples/Case3_Incomparability.lean)
- [`Architectures.lean`](../../../SE/StructuralAssurability/Layer90_Examples/Architectures.lean)
- [`Incomparability.lean`](../../../SE/StructuralAssurability/Layer40_Order/Incomparability.lean)
- [`Evaluator.lean`](../../../SE/StructuralAssurability/Layer10_Foundation/Evaluator.lean)
