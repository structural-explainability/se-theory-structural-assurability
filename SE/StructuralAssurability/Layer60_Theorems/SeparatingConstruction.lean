/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer40_Order
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
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
/--
A separating construction witnesses that a represented structural difference
between two systems produces an assurability distinction under some
comparative assurance context.
The `difference` relation is supplied by the application or theorem for the
candidate dimension being studied. It may encode both the focal structural
difference and whatever controls are required to hold other material
properties fixed.
The construction establishes non-equivalence. It does not by itself establish
directional dominance.
-/
public structure SeparatingConstruction
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
    (model :
      AssurabilityModel
        System
        World
        Evidence
        Capability
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (difference :
      CandidateStructuralDimension →
      System →
      System →
      Prop) where
  /-- Candidate structural dimension varied by the construction. -/
  dimension : CandidateStructuralDimension
  /-- Assurance context in which the separation is evaluated. -/
  context :
    ComparativeContext
      World
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation
      Budget
  /-- System with the lower comparison profile. -/
  lower : System
  /-- System with the upper comparison profile. -/
  upper : System
  dimensionDiffers : difference dimension lower upper
  notEquivalent :
    ¬ assurabilityEquivalent model context lower upper
/--
A candidate structural dimension is assurance-relevant relative to a stated
structural-difference relation and assurability model when there exists some
comparative assurance context and some pair of systems that differ according
to that relation and are not assurability-equivalent.
This formalizes the existential strength of the contribution criterion.
-/
public abbrev assuranceRelevantDimension
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
    (model :
      AssurabilityModel
        System
        World
        Evidence
        Capability
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (difference :
      CandidateStructuralDimension →
      System →
      System →
      Prop)
    (dimension : CandidateStructuralDimension) :
    Prop :=
  ∃ context lower upper,
    difference dimension lower upper ∧
    ¬ assurabilityEquivalent model context lower upper
/--
Every separating construction establishes assurance relevance for its
candidate structural dimension under the supplied difference relation.
-/
public theorem separatingConstruction_establishes_relevance
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
    (model :
      AssurabilityModel
        System
        World
        Evidence
        Capability
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (difference :
      CandidateStructuralDimension →
      System →
      System →
      Prop)
    (construction :
      SeparatingConstruction model difference) :
    assuranceRelevantDimension
      model
      difference
      construction.dimension := by
  exact ⟨
    construction.context,
    construction.lower,
    construction.upper,
    construction.dimensionDiffers,
    construction.notEquivalent
  ⟩
end SE.StructuralAssurability
