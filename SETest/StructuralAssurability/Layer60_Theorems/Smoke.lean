/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
import SE.StructuralAssurability.Layer60_Theorems
namespace SETest.StructuralAssurability.Layer60_Theorems
open SE.StructuralAssurability
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
section Access
variable {System : Type uSystem}
variable {Evidence : Type uEvidence}
variable {Evaluator : Type uEvaluator}
variable {Knowledge : Type uKnowledge}
variable {Access : Type uAccess}
variable {Trust : Type uTrust}
variable {Cooperation : Type uCooperation}
variable {Budget : Type uBudget}
variable
  (accessModel :
    EvidenceAccessModel
      System
      Evidence
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation)
variable
  (resourceModel :
    ResourceModel System Evidence Budget)
variable (system : System)
variable
  (weaker stronger :
    EvaluatorConditions
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation)
variable (budget : Budget)
example
    (expansion :
      accessExpansion
        accessModel
        system
        weaker
        stronger) :
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        weaker
        budget
      ⊆
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        stronger
        budget :=
  obtainableEvidence_mono_of_accessExpansion
    accessModel
    resourceModel
    system
    weaker
    stronger
    budget
    expansion
end Access
section Resources
variable {System : Type uSystem}
variable {Evidence : Type uEvidence}
variable {Evaluator : Type uEvaluator}
variable {Knowledge : Type uKnowledge}
variable {Access : Type uAccess}
variable {Trust : Type uTrust}
variable {Cooperation : Type uCooperation}
variable {Budget : Type uBudget}
variable
  (accessModel :
    EvidenceAccessModel
      System
      Evidence
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation)
variable
  (resourceModel :
    ResourceModel System Evidence Budget)
variable (system : System)
variable
  (conditions :
    EvaluatorConditions
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation)
variable (weaker stronger : Budget)
example
    (expansion :
      resourceExpansion
        resourceModel
        system
        weaker
        stronger) :
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        conditions
        weaker
      ⊆
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        conditions
        stronger :=
  obtainableEvidence_mono_of_resourceExpansion
    accessModel
    resourceModel
    system
    conditions
    weaker
    stronger
    expansion
end Resources
section Capability
variable {World : Type uWorld}
variable {Evidence : Type uEvidence}
variable {Capability : Type uCapability}
variable
  (capabilityModel :
    CapabilityModel World Evidence Capability)
variable
  (materiality :
    MaterialityStandard World Evidence)
variable (claim : Claim World)
variable (left right : EvidenceSet Evidence)
example
    (subset : left ⊆ right) :
    MaterialityStandard.claimMaterialEvidence
        materiality
        claim
        left
      ⊆
    MaterialityStandard.claimMaterialEvidence
        materiality
        claim
        right :=
  claimMaterialEvidence_mono
    materiality
    claim
    subset
example
    (monotone :
      capabilityMonotone capabilityModel)
    (subset : left ⊆ right) :
    CapabilityModel.capabilities
        capabilityModel
        claim
        (MaterialityStandard.claimMaterialEvidence
          materiality
          claim
          left)
      ⊆
    CapabilityModel.capabilities
        capabilityModel
        claim
        (MaterialityStandard.claimMaterialEvidence
          materiality
          claim
          right) :=
  claimMaterialCapabilities_mono
    capabilityModel
    materiality
    monotone
    claim
    subset
end Capability
section Separating
variable {System : Type uSystem}
variable {World : Type uWorld}
variable {Evidence : Type uEvidence}
variable {Capability : Type uCapability}
variable {Evaluator : Type uEvaluator}
variable {Knowledge : Type uKnowledge}
variable {Access : Type uAccess}
variable {Trust : Type uTrust}
variable {Cooperation : Type uCooperation}
variable {Budget : Type uBudget}
variable
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
variable
  (difference :
    CandidateStructuralDimension →
    System →
    System →
    Prop)
variable
  (construction :
    SeparatingConstruction model difference)
example :
    assuranceRelevantDimension
      model
      difference
      construction.dimension :=
  separatingConstruction_establishes_relevance
    model
    difference
    construction
end Separating
section Conservative
variable {System : Type uSystem}
variable {World : Type uWorld}
variable {Evidence : Type uEvidence}
variable {Capability : Type uCapability}
variable {Evaluator : Type uEvaluator}
variable {Knowledge : Type uKnowledge}
variable {Access : Type uAccess}
variable {Trust : Type uTrust}
variable {Cooperation : Type uCooperation}
variable {Budget : Type uBudget}
variable
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
variable
  (context :
    ComparativeContext
      World
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation
      Budget)
variable (base extension : System)
variable
  (witness :
    ConservativeExtensionWitness
      model
      context
      base
      extension)
example :
    strictlyMoreAssurable
      model
      context
      extension
      base :=
  conservativeExtension_strictlyMoreAssurable
    model
    context
    witness
example :
    ¬ assurabilityEquivalent
      model
      context
      extension
      base :=
  conservativeExtension_not_equivalent
    model
    context
    witness
end Conservative
end SETest.StructuralAssurability.Layer60_Theorems
