/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.StructuralAssurability.Layer30_Core

namespace SETest.StructuralAssurability.Layer30_Core

open SE.StructuralAssurability

inductive DemoSystem where
  | basic
  deriving DecidableEq

inductive DemoEvidence where
  | output
  | audit
  deriving DecidableEq

inductive DemoCapability where
  | inspectOutput
  | verifyAudit
  deriving DecidableEq

/--
The demonstration claim is true exactly in the `true` world.
-/
def demoClaim : Claim Bool where
  holds := fun world => world = true

def demoConditions :
    EvaluatorConditions Unit Unit Unit Unit Unit where
  evaluator := ()
  knowledge := ()
  access := ()
  trust := ()
  cooperation := ()

def demoContext :
    ComparativeContext Bool Unit Unit Unit Unit Unit Unit where
  claim := demoClaim
  conditions := demoConditions
  budget := ()

/--
Both evidence items are accessible.
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
Both evidence items are feasible within the demonstration budget.
-/
def demoResources :
    ResourceModel DemoSystem DemoEvidence Unit where
  feasible := fun _ _ _ => True

/--
Only audit evidence is material to the demonstration claim.
-/
def demoMateriality :
    MaterialityStandard Bool DemoEvidence where
  material := fun _ evidence =>
    evidence = DemoEvidence.audit

/--
Each demonstration capability requires its corresponding evidence item.

Because materiality removes ordinary output evidence, only `verifyAudit`
should survive into the final assurability profile.
-/
def demoCapabilities :
    CapabilityModel Bool DemoEvidence DemoCapability where
  enabled := fun _ evidenceSet capability =>
    match capability with
    | DemoCapability.inspectOutput =>
        DemoEvidence.output ∈ evidenceSet
    | DemoCapability.verifyAudit =>
        DemoEvidence.audit ∈ evidenceSet

def demoAssurabilityModel :
    AssurabilityModel
      DemoSystem
      Bool
      DemoEvidence
      DemoCapability
      Unit
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessModel := demoAccess
  resourceModel := demoResources
  materiality := demoMateriality
  capabilityModel := demoCapabilities

example :
    DemoCapability.verifyAudit ∈
      structuralAssurability
        demoAssurabilityModel
        DemoSystem.basic
        demoContext := by
  simp [
    structuralAssurability,
    AssurabilityModel.profile,
    CapabilityModel.systemCapabilities,
    CapabilityModel.capabilities,
    MaterialityStandard.claimMaterialEvidence,
    EvidenceAccessModel.obtainableEvidence,
    demoAssurabilityModel,
    demoAccess,
    demoResources,
    demoMateriality,
    demoCapabilities
  ]

example :
    DemoCapability.inspectOutput ∉
      structuralAssurability
        demoAssurabilityModel
        DemoSystem.basic
        demoContext := by
  simp [
    structuralAssurability,
    AssurabilityModel.profile,
    CapabilityModel.systemCapabilities,
    CapabilityModel.capabilities,
    MaterialityStandard.claimMaterialEvidence,
    EvidenceAccessModel.obtainableEvidence,
    demoAssurabilityModel,
    demoAccess,
    demoResources,
    demoMateriality,
    demoCapabilities
  ]

/--
A coarse observation model reveals nothing about which Boolean world holds.
-/
def coarseObservation :
    ObservationModel Bool Unit where
  observe := fun _ => ()

/--
The two Boolean worlds are observationally indistinguishable under the coarse
model but disagree on the demonstration claim.
-/
def demoFailureWitness :
    ResolutionFailureWitness
      (WorldSpace.unrestricted Bool)
      coarseObservation
      demoClaim where
  left := true
  right := false
  leftAdmissible := by
    trivial
  rightAdmissible := by
    trivial
  sameObservation := by
    rfl
  claimDisagrees := by
    simp [claimDisagreement, demoClaim]

example :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted Bool)
      coarseObservation
      demoClaim := by
  exact not_claimResolvedBy_of_witness demoFailureWitness

/--
An exact observation model exposes the Boolean world directly.
-/
def exactObservation :
    ObservationModel Bool Bool where
  observe := id

example :
    claimResolvedBy
      (WorldSpace.unrestricted Bool)
      exactObservation
      demoClaim := by
  intro left right _ _ sameObservation
  have equalWorlds : left = right := by
    simpa [indistinguishable, exactObservation] using sameObservation
  subst right
  rfl

end SETest.StructuralAssurability.Layer30_Core
