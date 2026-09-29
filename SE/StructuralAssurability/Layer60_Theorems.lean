/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all
public import SE.StructuralAssurability.Layer60_Theorems.SeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.AccessExpansion
public import SE.StructuralAssurability.Layer60_Theorems.ResourceExpansion
public import SE.StructuralAssurability.Layer60_Theorems.CapabilityMonotonicity
public import SE.StructuralAssurability.Layer60_Theorems.ConservativeExtension
public import SE.StructuralAssurability.Layer60_Theorems.CoverageSeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.ObservabilitySeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.ReconstructabilitySeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.TraceabilitySeparatingConstruction
/-!
# Layer 60: Theorems
General results connecting structural and contextual differences to
Structural Assurability.
This layer formalizes:
- the separating-construction criterion for structural contribution;
- access expansion and obtainable-evidence monotonicity;
- resource expansion and obtainable-evidence monotonicity;
- claim-material evidence monotonicity;
- capability monotonicity as an explicit additional assumption; and
- conservative capability extension as sufficient for strict comparative
  assurability.
The logical strength is deliberately bounded.
A separating construction establishes that a represented structural
difference matters in at least one assurance context. It does not establish
universal necessity, universal monotonicity, independence, completeness, or
joint sufficiency of the candidate structural dimensions.
Likewise, expanded access or resources can preserve or enlarge obtainable
evidence without producing a strict increase in Structural Assurability.
-/
