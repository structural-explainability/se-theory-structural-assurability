/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.StructuralAssurability.Layer20_Semantics

namespace SETest.StructuralAssurability.Layer20_Semantics

open SE.StructuralAssurability

inductive DemoSystem where
  | basic
  deriving DecidableEq

inductive DemoEvidence where
  | output
  | audit
  deriving DecidableEq

/--
A minimal claim whose truth differs between the two Boolean worlds.
-/
def demoClaim : Claim Bool where
  holds := fun world => world = true

/--
An observation model that directly exposes the Boolean world.
-/
def demoObservation : ObservationModel Bool Bool where
  observe := id

example : indistinguishable demoObservation true true := by
  rfl

example : ¬ indistinguishable demoObservation true false := by
  simp [indistinguishable, demoObservation]

example : claimDisagreement demoClaim true false := by
  simp [claimDisagreement, demoClaim]

example :
    ¬ admissiblyIndistinguishable
      (WorldSpace.unrestricted Bool)
      demoObservation
      true
      false := by
  simp [
    admissiblyIndistinguishable,
    indistinguishable,
    demoObservation,
  ]

/--
Minimal evaluator conditions used to exercise accessibility semantics.
-/
def demoConditions :
    EvaluatorConditions Unit Unit Unit Unit Unit where
  evaluator := ()
  knowledge := ()
  access := ()
  trust := ()
  cooperation := ()

/--
All evidence is accessible under the demonstration access model.
-/
def demoAccess :
    EvidenceAccessModel
      DemoSystem
      DemoEvidence
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessible := fun _ _ _ => True

/--
Only the ordinary output is feasible under the demonstration resource
budget.
-/
def demoResources :
    ResourceModel DemoSystem DemoEvidence Unit where
  feasible := fun _ _ evidence => evidence = DemoEvidence.output

example :
    DemoEvidence.output ∈
      EvidenceAccessModel.accessibleEvidence
        demoAccess
        DemoSystem.basic
        demoConditions := by
  simp [
    EvidenceAccessModel.accessibleEvidence,
    demoAccess
  ]

example :
    DemoEvidence.output ∈
      EvidenceAccessModel.obtainableEvidence
        demoAccess
        demoResources
        DemoSystem.basic
        demoConditions
        () := by
  simp [
    EvidenceAccessModel.obtainableEvidence,
    demoAccess,
    demoResources
  ]

example :
    DemoEvidence.audit ∉
      EvidenceAccessModel.obtainableEvidence
        demoAccess
        demoResources
        DemoSystem.basic
        demoConditions
        () := by
  simp [
    EvidenceAccessModel.obtainableEvidence,
    demoAccess,
    demoResources
  ]

/--
Only audit evidence is material under this demonstration materiality
standard.
-/
def demoMateriality :
    MaterialityStandard Bool DemoEvidence where
  material := fun _ evidence => evidence = DemoEvidence.audit

example :
    DemoEvidence.audit ∈
      MaterialityStandard.claimMaterialEvidence
        demoMateriality
        demoClaim
        Set.univ := by
  simp [
    MaterialityStandard.claimMaterialEvidence,
    demoMateriality
  ]

example :
    DemoEvidence.output ∉
      MaterialityStandard.claimMaterialEvidence
        demoMateriality
        demoClaim
        Set.univ := by
  simp [
    MaterialityStandard.claimMaterialEvidence,
    demoMateriality
  ]

/--
A demonstration sufficiency standard requiring audit evidence.

This test does not assert that the standard is substantively appropriate.
It verifies only that sufficiency remains an explicit, separately supplied
relation.
-/
def demoSufficiency :
    SufficiencyStandard Bool DemoEvidence where
  sufficient := fun _ evidenceSet =>
    DemoEvidence.audit ∈ evidenceSet

example :
    SufficiencyStandard.isSufficient
      demoSufficiency
      demoClaim
      Set.univ := by
  simp [
    SufficiencyStandard.isSufficient,
    demoSufficiency
  ]

end SETest.StructuralAssurability.Layer20_Semantics
