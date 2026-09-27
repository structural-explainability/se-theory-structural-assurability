/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer40_Order.Dominance
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
Two systems are incomparable under a fixed model and comparative assurance
context when neither Structural Assurability profile contains the other.
This is the formal counterpart of the manuscript relation `S₁ ∥q S₂`.
-/
public abbrev assurabilityIncomparable
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (left right : System) :
    Prop :=
  ¬ atLeastAsAssurable model context left right ∧
    ¬ atLeastAsAssurable model context right left
/--
Assurability incomparability is symmetric.
-/
public theorem assurabilityIncomparable_symm
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    {left right : System}
    (incomparable :
      assurabilityIncomparable model context left right) :
    assurabilityIncomparable model context right left := by
  exact ⟨incomparable.2, incomparable.1⟩
/--
Incomparable systems cannot be assurability-equivalent.
-/
public theorem assurabilityIncomparable_not_equivalent
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    {left right : System}
    (incomparable :
      assurabilityIncomparable model context left right) :
    ¬ assurabilityEquivalent model context left right := by
  intro equivalent
  have bothDirections :=
    (assurabilityEquivalent_iff_mutual_dominance
      model
      context
      left
      right).mp equivalent
  exact incomparable.1 bothDirections.1
end SE.StructuralAssurability
