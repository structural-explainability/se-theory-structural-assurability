/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer50_Properties.Traceability
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
  uTraceTarget

/-!
# Traceability-specific separating constructions

The difference relation fixes one evidence item and compares the
trace-target profiles associated with that item in two systems.

The relation is restricted to the traceability dimension.
Establishing assurance relevance additionally requires independently
proved Structural Assurability non-equivalence.

## Modeling limitation

A traceability-profile difference establishes a difference in the
targets represented as traceable for the selected evidence item.

It does not establish that the attributed origins, actors, events,
or relationships are authentic or correctly identified. The model
does not verify the integrity of the underlying traceability records
or the trust assumptions governing their production and preservation.

A traceability-profile difference does not independently establish
a difference in evidentiary capabilities or claim resolution.
-/

/--
Dimension-locked, profile-grounded difference relation for traceability, at
one fixed evidence item. Defined only for `.traceability`; every other
dimension is `False`.
-/
@[expose] public def traceabilityDifference
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {TraceTarget : Type uTraceTarget}
    (traceModel : TraceabilityModel System Evidence TraceTarget)
    (evidence : Evidence) :
    CandidateStructuralDimension → System → System → Prop
  | .traceability, lower, upper =>
      TraceabilityModel.targets traceModel lower evidence ⊂
        TraceabilityModel.targets traceModel upper evidence
  | _, _, _ => False

/-- `traceabilityDifference` can only ever witness `.traceability`. -/
public theorem traceabilityDifference_only_traceability
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {TraceTarget : Type uTraceTarget}
    (traceModel : TraceabilityModel System Evidence TraceTarget)
    (evidence : Evidence)
    {dimension : CandidateStructuralDimension}
    {lower upper : System}
    (differs : traceabilityDifference traceModel evidence dimension lower upper) :
    dimension = .traceability := by
  cases dimension
  case traceability => rfl
  all_goals exact differs.elim

/--
Constructs a traceability-specific `SeparatingConstruction` from
strict inclusion of trace-target profiles for a fixed evidence item
and independently established Structural Assurability non-equivalence.

The construction does not establish the authenticity or integrity
of the underlying traceability records.
-/
public def SeparatingConstruction.ofTraceability
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
    {TraceTarget : Type uTraceTarget}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (traceModel : TraceabilityModel System Evidence TraceTarget)
    (traceEvidence : Evidence)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreTraceable :
      TraceabilityModel.targets traceModel lower traceEvidence ⊂
        TraceabilityModel.targets traceModel upper traceEvidence)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    SeparatingConstruction model (traceabilityDifference traceModel traceEvidence) where
  dimension := .traceability
  context := context
  lower := lower
  upper := upper
  dimensionDiffers := strictlyMoreTraceable
  notEquivalent := notEquivalent

/-- The traceability-specific route to `assuranceRelevantDimension`. -/
public theorem traceability_assuranceRelevant_of_profile_difference
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
    {TraceTarget : Type uTraceTarget}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (traceModel : TraceabilityModel System Evidence TraceTarget)
    (traceEvidence : Evidence)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreTraceable :
      TraceabilityModel.targets traceModel lower traceEvidence ⊂
        TraceabilityModel.targets traceModel upper traceEvidence)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    assuranceRelevantDimension
      model (traceabilityDifference traceModel traceEvidence) .traceability :=
  separatingConstruction_establishes_relevance
    model
    (traceabilityDifference traceModel traceEvidence)
    (SeparatingConstruction.ofTraceability
      model traceModel traceEvidence context lower upper
      strictlyMoreTraceable notEquivalent)

end SE.StructuralAssurability
