/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer50_Properties.Reconstructability
public import SE.StructuralAssurability.Layer60_Theorems.SeparatingConstruction

namespace SE.StructuralAssurability

universe
  uSystem
  uWorld
  uEvidence
  uCapability
  uEvaluator
  uKnowledge
  uAccess
  uTrust
  uCooperation
  uBudget
  uReconstructionTarget

/-!
# Reconstructability-specific separating constructions

The difference relation compares the reconstruction-target profiles of
two systems under a specified `ReconstructabilityModel`.

The relation is restricted to the reconstructability dimension.
It holds when the lower system's reconstruction-target profile is
a strict subset of the upper system's profile.

The smart constructor combines this structural difference with
independently established Structural Assurability non-equivalence
to establish reconstructability relevance.

## Modeling limitation

A reconstructability-profile difference establishes a difference
in the targets represented as reconstructable by the two systems.

It does not establish that the records or other evidence supporting
a reconstruction are authentic, complete, unaltered, or sufficient.

Evidence integrity and the applicable trust assumptions remain
separate obligations. A reconstructability-profile difference
does not independently establish a difference in evidentiary
capabilities or claim resolution.
-/

/--
Dimension-locked, profile-grounded difference relation for reconstructability.

For `.reconstructability`, the relation requires strict inclusion of
reconstruction-target profiles. For every other dimension, it is `False`.
-/
@[expose] public def reconstructabilityDifference
    {System : Type uSystem}
    {ReconstructionTarget : Type uReconstructionTarget}
    (reconModel : ReconstructabilityModel System ReconstructionTarget) :
    CandidateStructuralDimension → System → System → Prop
  | .reconstructability, lower, upper =>
      ReconstructabilityModel.profile reconModel lower ⊂
        ReconstructabilityModel.profile reconModel upper
  | _, _, _ => False

/-- `reconstructabilityDifference` can only ever witness `.reconstructability`. -/
public theorem reconstructabilityDifference_only_reconstructability
    {System : Type uSystem}
    {ReconstructionTarget : Type uReconstructionTarget}
    (reconModel : ReconstructabilityModel System ReconstructionTarget)
    {dimension : CandidateStructuralDimension}
    {lower upper : System}
    (differs : reconstructabilityDifference reconModel dimension lower upper) :
    dimension = .reconstructability := by
  cases dimension
  case reconstructability => rfl
  all_goals exact differs.elim

/--
Constructs a reconstructability-specific `SeparatingConstruction` from
strict inclusion of reconstruction-target profiles and independently
established Structural Assurability non-equivalence.

The construction fixes the dimension to `.reconstructability`.
It does not establish the authenticity or integrity of the
underlying reconstruction evidence.
-/
public def SeparatingConstruction.ofReconstructability
    {System : Type uSystem}
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    {Evaluator : Type uEvaluator}
    {Knowledge : Type uKnowledge}
    {Access : Type uAccess}
    {Trust : Type uTrust}
    {Cooperation : Type uCooperation}
    {Budget : Type uBudget}
    {ReconstructionTarget : Type uReconstructionTarget}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (reconModel : ReconstructabilityModel System ReconstructionTarget)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreReconstructable :
      ReconstructabilityModel.profile reconModel lower ⊂
        ReconstructabilityModel.profile reconModel upper)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    SeparatingConstruction model (reconstructabilityDifference reconModel) where
  dimension := .reconstructability
  context := context
  lower := lower
  upper := upper
  dimensionDiffers := strictlyMoreReconstructable
  notEquivalent := notEquivalent

/-- The reconstructability-specific route to `assuranceRelevantDimension`. -/
public theorem reconstructability_assuranceRelevant_of_profile_difference
    {System : Type uSystem}
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    {Evaluator : Type uEvaluator}
    {Knowledge : Type uKnowledge}
    {Access : Type uAccess}
    {Trust : Type uTrust}
    {Cooperation : Type uCooperation}
    {Budget : Type uBudget}
    {ReconstructionTarget : Type uReconstructionTarget}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (reconModel : ReconstructabilityModel System ReconstructionTarget)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreReconstructable :
      ReconstructabilityModel.profile reconModel lower ⊂
        ReconstructabilityModel.profile reconModel upper)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    assuranceRelevantDimension
      model (reconstructabilityDifference reconModel) .reconstructability :=
  separatingConstruction_establishes_relevance
    model
    (reconstructabilityDifference reconModel)
    (SeparatingConstruction.ofReconstructability
      model reconModel context lower upper
      strictlyMoreReconstructable notEquivalent)

end SE.StructuralAssurability
