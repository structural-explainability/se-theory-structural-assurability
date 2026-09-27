/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
import SE.StructuralAssurability.Layer40_Order
namespace SETest.StructuralAssurability.Layer40_Order
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
section EvidenceOrder
variable {World : Type uWorld}
variable {Evidence : Type uEvidence}
variable {Capability : Type uCapability}
variable (model : CapabilityModel World Evidence Capability)
variable (claim : Claim World)
variable (first second third : EvidenceSet Evidence)
example :
    evidenceCapabilityLe model claim first first :=
  evidenceCapabilityLe_refl model claim first
example
    (firstLeSecond :
      evidenceCapabilityLe model claim first second)
    (secondLeThird :
      evidenceCapabilityLe model claim second third) :
    evidenceCapabilityLe model claim first third :=
  evidenceCapabilityLe_trans
    model
    claim
    firstLeSecond
    secondLeThird
example :
    evidenceCapabilityEquivalent model claim first first :=
  evidenceCapabilityEquivalent_refl model claim first
example
    (firstEqSecond :
      evidenceCapabilityEquivalent model claim first second) :
    evidenceCapabilityEquivalent model claim second first :=
  evidenceCapabilityEquivalent_symm
    model
    claim
    firstEqSecond
example
    (firstEqSecond :
      evidenceCapabilityEquivalent model claim first second)
    (secondEqThird :
      evidenceCapabilityEquivalent model claim second third) :
    evidenceCapabilityEquivalent model claim first third :=
  evidenceCapabilityEquivalent_trans
    model
    claim
    firstEqSecond
    secondEqThird
example :
    evidenceCapabilityEquivalent model claim first second ↔
      evidenceCapabilityLe model claim first second ∧
      evidenceCapabilityLe model claim second first :=
  evidenceCapabilityEquivalent_iff_mutual_le
    model
    claim
    first
    second
end EvidenceOrder
section SystemOrder
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
variable (first second third : System)
example :
    atLeastAsAssurable model context first first :=
  atLeastAsAssurable_refl model context first
example
    (firstGeSecond :
      atLeastAsAssurable model context first second)
    (secondGeThird :
      atLeastAsAssurable model context second third) :
    atLeastAsAssurable model context first third :=
  atLeastAsAssurable_trans
    model
    context
    firstGeSecond
    secondGeThird
example :
    assurabilityEquivalent model context first first :=
  assurabilityEquivalent_refl model context first
example
    (firstEqSecond :
      assurabilityEquivalent model context first second) :
    assurabilityEquivalent model context second first :=
  assurabilityEquivalent_symm
    model
    context
    firstEqSecond
example
    (firstEqSecond :
      assurabilityEquivalent model context first second)
    (secondEqThird :
      assurabilityEquivalent model context second third) :
    assurabilityEquivalent model context first third :=
  assurabilityEquivalent_trans
    model
    context
    firstEqSecond
    secondEqThird
example :
    assurabilityEquivalent model context first second ↔
      atLeastAsAssurable model context first second ∧
      atLeastAsAssurable model context second first :=
  assurabilityEquivalent_iff_mutual_dominance
    model
    context
    first
    second
example
    (strict :
      strictlyMoreAssurable model context first second) :
    atLeastAsAssurable model context first second :=
  strictlyMoreAssurable_atLeast
    model
    context
    strict
example
    (strict :
      strictlyMoreAssurable model context first second) :
    ¬ assurabilityEquivalent model context first second :=
  strictlyMoreAssurable_not_equivalent
    model
    context
    strict
example
    (incomparable :
      assurabilityIncomparable model context first second) :
    assurabilityIncomparable model context second first :=
  assurabilityIncomparable_symm
    model
    context
    incomparable
example
    (incomparable :
      assurabilityIncomparable model context first second) :
    ¬ assurabilityEquivalent model context first second :=
  assurabilityIncomparable_not_equivalent
    model
    context
    incomparable
end SystemOrder
end SETest.StructuralAssurability.Layer40_Order
