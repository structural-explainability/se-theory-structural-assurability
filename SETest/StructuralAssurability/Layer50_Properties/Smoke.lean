/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
import SE.StructuralAssurability.Layer50_Properties
namespace SETest.StructuralAssurability.Layer50_Properties
open SE.StructuralAssurability
inductive DemoSystem where
  | opaque
  | instrumented
  deriving DecidableEq
inductive DemoObservable where
  | externalOutput
  | internalState
  deriving DecidableEq
inductive DemoCondition where
  | ordinary
  | fault
  deriving DecidableEq
inductive DemoIntervention where
  | replay
  deriving DecidableEq
inductive DemoEvidence where
  | output
  | audit
  deriving DecidableEq
inductive DemoTraceTarget where
  | origin
  | history
  deriving DecidableEq
inductive DemoReconstructionTarget where
  | execution
  deriving DecidableEq
inductive DemoSubject where
  | component
  deriving DecidableEq
inductive DemoCoverageElement where
  | externalAction
  | internalDecision
  deriving DecidableEq
def demoObservability :
    ObservabilityModel DemoSystem DemoObservable where
  observable := fun system feature =>
    feature = DemoObservable.externalOutput ∨
      system = DemoSystem.instrumented
example :
    DemoObservable.externalOutput ∈
      demoObservability.profile DemoSystem.opaque := by
  simp [demoObservability]
example :
    DemoObservable.internalState ∉
      demoObservability.profile DemoSystem.opaque := by
  simp [demoObservability]
example :
    DemoObservable.internalState ∈
      demoObservability.profile DemoSystem.instrumented := by
  simp [demoObservability]
def demoControllability :
    ControllabilityModel
      DemoSystem
      DemoCondition
      DemoIntervention where
  establishable := fun system condition =>
    condition = DemoCondition.ordinary ∨
      system = DemoSystem.instrumented
  performable := fun system _ =>
    system = DemoSystem.instrumented
example :
    DemoCondition.fault ∉
      demoControllability.conditionProfile DemoSystem.opaque := by
  simp [demoControllability]
example :
    DemoCondition.fault ∈
      demoControllability.conditionProfile DemoSystem.instrumented := by
  simp [demoControllability]
example :
    DemoIntervention.replay ∈
      demoControllability.interventionProfile
        DemoSystem.instrumented := by
  simp [demoControllability]
def demoTraceability :
    TraceabilityModel
      DemoSystem
      DemoEvidence
      DemoTraceTarget where
  traceable := fun system evidence target =>
    system = DemoSystem.instrumented ∧
      evidence = DemoEvidence.audit ∧
      (target = DemoTraceTarget.origin ∨
        target = DemoTraceTarget.history)
example :
    DemoTraceTarget.origin ∈
      demoTraceability.targets
        DemoSystem.instrumented
        DemoEvidence.audit := by
  simp [demoTraceability]
example :
    DemoTraceTarget.origin ∉
      demoTraceability.targets
        DemoSystem.opaque
        DemoEvidence.audit := by
  simp [demoTraceability]
def demoReconstructability :
    ReconstructabilityModel
      DemoSystem
      DemoReconstructionTarget where
  reconstructable := fun system _ =>
    system = DemoSystem.instrumented
example :
    DemoReconstructionTarget.execution ∈
      demoReconstructability.profile
        DemoSystem.instrumented := by
  simp [demoReconstructability]
example :
    DemoReconstructionTarget.execution ∉
      demoReconstructability.profile
        DemoSystem.opaque := by
  simp [demoReconstructability]
def demoIndependence :
    IndependenceModel
      DemoSystem
      DemoEvidence
      DemoSubject where
  independent := fun system evidence _ mode =>
    system = DemoSystem.instrumented ∧
      evidence = DemoEvidence.audit ∧
      mode = IndependenceMode.corroborated
example :
    DemoEvidence.audit ∈
      demoIndependence.independentEvidence
        DemoSystem.instrumented
        DemoSubject.component
        IndependenceMode.corroborated := by
  simp [demoIndependence]
example :
    DemoEvidence.audit ∉
      demoIndependence.independentEvidence
        DemoSystem.instrumented
        DemoSubject.component
        IndependenceMode.generated := by
  simp [demoIndependence]
def demoIntegrity :
    IntegrityModel DemoSystem DemoEvidence where
  detectsOrPrevents := fun system evidence _ =>
    system = DemoSystem.instrumented ∧
      evidence = DemoEvidence.audit
example :
    DemoEvidence.audit ∈
      demoIntegrity.protectedEvidence
        DemoSystem.instrumented
        EvidenceIntegrityThreat.alteration := by
  simp [demoIntegrity]
example :
    DemoEvidence.output ∉
      demoIntegrity.protectedEvidence
        DemoSystem.instrumented
        EvidenceIntegrityThreat.alteration := by
  simp [demoIntegrity]
def demoCoverage :
    EvidenceCoverageModel
      DemoSystem
      DemoCoverageElement where
  covered := fun system element =>
    element = DemoCoverageElement.externalAction ∨
      system = DemoSystem.instrumented
example :
    DemoCoverageElement.externalAction ∈
      demoCoverage.profile DemoSystem.opaque := by
  simp [demoCoverage]
example :
    DemoCoverageElement.internalDecision ∉
      demoCoverage.profile DemoSystem.opaque := by
  simp [demoCoverage]
example :
    DemoCoverageElement.internalDecision ∈
      demoCoverage.profile DemoSystem.instrumented := by
  simp [demoCoverage]
end SETest.StructuralAssurability.Layer50_Properties
