/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all

public import SE.StructuralAssurability.Layer20_Semantics.Observation
public import SE.StructuralAssurability.Layer20_Semantics.Resources
public import SE.StructuralAssurability.Layer20_Semantics.Accessibility
public import SE.StructuralAssurability.Layer20_Semantics.Materiality
public import SE.StructuralAssurability.Layer20_Semantics.Sufficiency
public import SE.StructuralAssurability.Layer20_Semantics.Indistinguishability

/-!
# Layer 20: Semantics

Semantic machinery for Structural Assurability.

This layer distinguishes:

- observation from the world being observed;
- access conditions from resource feasibility;
- obtainable evidence from all conceivable evidence;
- claim-material evidence from merely available evidence;
- evidence availability from downstream evidentiary sufficiency; and
- world identity from observational distinguishability.

These distinctions support the later definition of Structural Assurability
without yet imposing a comparative ordering on systems.

Observation            What a world exposes.
Resources              What evidence is feasible within B.
Accessibility          What evidence K permits the evaluator to access.
                       Accessibility ∩ feasibility = practically obtainable evidence.
Materiality            Which obtainable evidence legitimately bears on C.
Sufficiency            A downstream standard for whether evidence is enough for C.
Indistinguishability   Which admissible worlds remain observationally identical.
-/
