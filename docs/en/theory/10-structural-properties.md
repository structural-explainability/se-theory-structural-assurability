# Candidate Structural Properties

The current formalization represents seven candidate structural properties:

- observability
- controllability
- traceability
- reconstructability
- independence
- integrity
- evidence coverage

These are candidate contributors to Structural Assurability rather than a
complete taxonomy.

The theory does not assume that they are mutually independent, universally
necessary, jointly sufficient, or universally monotone.

A candidate property contributes to the theory when a separating construction
can demonstrate an assurance-relevant distinction associated with that
property.

## Dimension-Specific Separating Constructions

The formalization provides dimension-locked, profile-grounded
separating constructions for four candidate properties:

- **Observability**: strict inclusion of observable-feature profiles.
- **Evidence coverage**: strict inclusion of covered-element profiles,
  with an additional controlled variant isolating one named element.
- **Traceability**: strict inclusion of trace-target profiles for
  a specified evidence item.
- **Reconstructability**: strict inclusion of reconstructable-target profiles.

Each difference relation can certify only its designated dimension.

The corresponding smart constructors also require independently
established Structural Assurability non-equivalence.

A structural-property profile difference does not, by itself,
establish a difference in evidentiary capabilities or claim resolution.

The general separating-construction interface remains available
and permits arbitrary caller-supplied difference relations.

## Source of Truth

- [CandidateDimension.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer50_Properties/CandidateDimension.lean)
- [Layer50_Properties.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer50_Properties.lean)
- [SeparatingConstruction.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer60_Theorems/SeparatingConstruction.lean)
- [CoverageSeparatingConstruction.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer60_Theorems/CoverageSeparatingConstruction.lean)
- [ObservabilitySeparatingConstruction.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer60_Theorems/ObservabilitySeparatingConstruction.lean)
- [ReconstructabilitySeparatingConstruction.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer60_Theorems/ReconstructabilitySeparatingConstruction.lean)
- [TraceabilitySeparatingConstruction.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer60_Theorems/TraceabilitySeparatingConstruction.lean)
