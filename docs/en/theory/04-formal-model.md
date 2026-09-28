# Formal Model

For a system `S`,
claim `C`,
evaluator conditions `K`,
and resource bounds `B`,
Structural Assurability is represented schematically as:

```text
A(S, C, K, B)
```

The formalization does not reduce this object to a number.

Instead, it derives a profile of evidentiary capabilities available
for the specified system and assurance context.

The conceptual flow is:

```text
accessible evidence
        ∩
resource-feasible evidence
        ↓
obtainable evidence
        ↓
claim-material evidence
        ↓
evidentiary capabilities
        ↓
Structural Assurability profile
```

Each stage is represented separately so that access, resources, materiality,
and capability semantics are not silently conflated.

## Source of Truth

- [Accessibility.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer20_Semantics/Accessibility.lean)
- [Resources.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer20_Semantics/Resources.lean)
- [Materiality.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer20_Semantics/Materiality.lean)
- [Capability.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/Capability.lean)
- [Assurability.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/Assurability.lean)
