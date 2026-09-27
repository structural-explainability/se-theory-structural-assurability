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
A conservative Structural Assurability extension preserves every capability
available from a base system and provides at least one additional capability
under the same assurance model and comparative context.
-/
public structure ConservativeExtensionWitness
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
    (base extension : System) where
  preserves :
    atLeastAsAssurable
      model
      context
      extension
      base
  additionalCapability :
    ∃ capability,
      capability ∈
        structuralAssurability model extension context ∧
      capability ∉
        structuralAssurability model base context
/--
A conservative extension is strictly more assurable than its base system
under the specified context.
-/
public theorem conservativeExtension_strictlyMoreAssurable
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
    {base extension : System}
    (witness :
      ConservativeExtensionWitness
        model
        context
        base
        extension) :
    strictlyMoreAssurable
      model
      context
      extension
      base := by
  constructor
  · exact witness.preserves
  · intro reverseDominance
    obtain ⟨capability, inExtension, notInBase⟩ :=
      witness.additionalCapability
    exact notInBase (reverseDominance inExtension)
/--
A conservative extension cannot be assurability-equivalent to its base
system under the same context.
-/
public theorem conservativeExtension_not_equivalent
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
    {base extension : System}
    (witness :
      ConservativeExtensionWitness
        model
        context
        base
        extension) :
    ¬ assurabilityEquivalent
      model
      context
      extension
      base := by
  apply strictlyMoreAssurable_not_equivalent
    model
    context
  exact conservativeExtension_strictlyMoreAssurable
    model
    context
    witness
end SE.StructuralAssurability
