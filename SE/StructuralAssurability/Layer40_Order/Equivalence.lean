/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer40_Order.EvidencePreorder
public import SE.StructuralAssurability.Layer30_Core.Assurability
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
Two evidence sets are evidentially equivalent for a claim when they enable
the same evidentiary capabilities.
Equality of the raw evidence artifacts is not required.
-/
public abbrev evidenceCapabilityEquivalent
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    (left right : EvidenceSet Evidence) :
    Prop :=
  CapabilityModel.capabilities model claim left =
    CapabilityModel.capabilities model claim right
/--
Evidentiary equivalence is reflexive.
-/
public theorem evidenceCapabilityEquivalent_refl
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    (evidenceSet : EvidenceSet Evidence) :
    evidenceCapabilityEquivalent model claim evidenceSet evidenceSet := by
  rfl
/--
Evidentiary equivalence is symmetric.
-/
public theorem evidenceCapabilityEquivalent_symm
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    {left right : EvidenceSet Evidence}
    (equivalent :
      evidenceCapabilityEquivalent model claim left right) :
    evidenceCapabilityEquivalent model claim right left := by
  exact equivalent.symm
/--
Evidentiary equivalence is transitive.
-/
public theorem evidenceCapabilityEquivalent_trans
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    {first second third : EvidenceSet Evidence}
    (firstEqSecond :
      evidenceCapabilityEquivalent model claim first second)
    (secondEqThird :
      evidenceCapabilityEquivalent model claim second third) :
    evidenceCapabilityEquivalent model claim first third := by
  exact firstEqSecond.trans secondEqThird
/--
Two evidence sets are evidentially equivalent exactly when each is no more
capable than the other.
This establishes the equivalence classes induced by the evidence-capability
preorder.
-/
public theorem evidenceCapabilityEquivalent_iff_mutual_le
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    (left right : EvidenceSet Evidence) :
    evidenceCapabilityEquivalent model claim left right ↔
      evidenceCapabilityLe model claim left right ∧
      evidenceCapabilityLe model claim right left := by
  constructor
  · intro equivalent
    constructor
    · change
        CapabilityModel.capabilities model claim left ⊆
          CapabilityModel.capabilities model claim right
      rw [equivalent]
    · change
        CapabilityModel.capabilities model claim right ⊆
          CapabilityModel.capabilities model claim left
      rw [equivalent]
  · rintro ⟨leftLeRight, rightLeLeft⟩
    change
      CapabilityModel.capabilities model claim left =
        CapabilityModel.capabilities model claim right
    exact Set.Subset.antisymm leftLeRight rightLeLeft
/--
Two systems are assurability-equivalent under a fixed model and comparative
assurance context when they have identical Structural Assurability profiles.
This is the formal counterpart of the manuscript relation `S₁ ~q S₂`.
-/
public abbrev assurabilityEquivalent
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
  structuralAssurability model left context =
    structuralAssurability model right context
/--
Assurability equivalence is reflexive.
-/
public theorem assurabilityEquivalent_refl
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
    (system : System) :
    assurabilityEquivalent model context system system := by
  rfl
/--
Assurability equivalence is symmetric.
-/
public theorem assurabilityEquivalent_symm
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
    (equivalent :
      assurabilityEquivalent model context left right) :
    assurabilityEquivalent model context right left := by
  exact equivalent.symm
/--
Assurability equivalence is transitive.
-/
public theorem assurabilityEquivalent_trans
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
    {first second third : System}
    (firstEqSecond :
      assurabilityEquivalent model context first second)
    (secondEqThird :
      assurabilityEquivalent model context second third) :
    assurabilityEquivalent model context first third := by
  exact firstEqSecond.trans secondEqThird
end SE.StructuralAssurability
