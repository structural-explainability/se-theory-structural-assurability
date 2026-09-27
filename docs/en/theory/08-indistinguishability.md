# Indistinguishability

A central bound in the theory concerns observational indistinguishability.

Consider two admissible possible worlds that differ in a fact relevant to the
claim.
For example:

```text
World 1: no unauthorized consequential action occurred
World 2: an unauthorized consequential action occurred
```

If the claim is true in one world and false in the other, but the evaluator
receives the same observation in both worlds,
that observation cannot resolve the claim.

The important issue is that the worlds may differ in
events, state, provenance, authorization, actions, or any other
claim-relevant fact represented by the model.

The formal bound is therefore:

```text
admissible worlds
+ identical observation
+ disagreement on claim truth
→ claim not resolved by that observation model
```

## Source of Truth

- [Indistinguishability.lean](../../../SE/StructuralAssurability/Layer20_Semantics/Indistinguishability.lean)
- [Bounds.lean](../../../SE/StructuralAssurability/Layer30_Core/Bounds.lean)
- [Case1_UnauthorizedAction.lean](../../../SE/StructuralAssurability/Layer90_Examples/Case1_UnauthorizedAction.lean)
