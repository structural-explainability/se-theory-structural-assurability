/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer50_Properties.Observability
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
  uObservable

/-!
# Observability-specific separating constructions

The difference relation compares the observable-feature profiles of
two systems under a specified `ObservabilityModel`.

The relation is restricted to the observability dimension.
It holds when the lower system's observable-feature profile is
a strict subset of the upper system's profile.

The smart constructor combines this structural difference with
independently established Structural Assurability non-equivalence
to establish observability relevance.

## Modeling limitation

A difference in observable-feature profiles does not independently
establish a difference in evidentiary capabilities or claim resolution.

This construction does not derive capability-profile non-equivalence
from observability-profile inclusion.
That non-equivalence remains a separate proof obligation.
-/

/--
Dimension-locked, profile-grounded difference relation for observability.

For `.observability`, the relation requires strict inclusion of
observable-feature profiles. For every other dimension, it is `False`.
-/
@[expose] public def observabilityDifference
    {System : Type uSystem}
    {Observable : Type uObservable}
    (obsModel : ObservabilityModel System Observable) :
    CandidateStructuralDimension → System → System → Prop
  | .observability, lower, upper =>
      ObservabilityModel.profile obsModel lower ⊂
        ObservabilityModel.profile obsModel upper
  | _, _, _ => False

/--
A satisfied `observabilityDifference` relation can witness only
the observability dimension.
-/
public theorem observabilityDifference_only_observability
    {System : Type uSystem}
    {Observable : Type uObservable}
    (obsModel : ObservabilityModel System Observable)
    {dimension : CandidateStructuralDimension}
    {lower upper : System}
    (differs : observabilityDifference obsModel dimension lower upper) :
    dimension = .observability := by
  cases dimension
  case observability => rfl
  all_goals exact differs.elim

/--
Constructs an observability-specific `SeparatingConstruction` from
strict inclusion of observable-feature profiles and independently
established Structural Assurability non-equivalence.

The construction fixes the dimension to `.observability`.
-/
public def SeparatingConstruction.ofObservability
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
    {Observable : Type uObservable}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (obsModel : ObservabilityModel System Observable)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreObservable :
      ObservabilityModel.profile obsModel lower ⊂
        ObservabilityModel.profile obsModel upper)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    SeparatingConstruction model (observabilityDifference obsModel) where
  dimension := .observability
  context := context
  lower := lower
  upper := upper
  dimensionDiffers := strictlyMoreObservable
  notEquivalent := notEquivalent

/--
Derives observability relevance from strict observable-feature profile
inclusion and independently established Structural Assurability
non-equivalence.

Uses the observability-specific smart constructor and the generic
separating-construction relevance theorem.
-/
public theorem observability_assuranceRelevant_of_profile_difference
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
    {Observable : Type uObservable}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (obsModel : ObservabilityModel System Observable)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreObservable :
      ObservabilityModel.profile obsModel lower ⊂
        ObservabilityModel.profile obsModel upper)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    assuranceRelevantDimension
      model (observabilityDifference obsModel) .observability :=
  separatingConstruction_establishes_relevance
    model
    (observabilityDifference obsModel)
    (SeparatingConstruction.ofObservability
      model obsModel context lower upper
      strictlyMoreObservable notEquivalent)

end SE.StructuralAssurability
