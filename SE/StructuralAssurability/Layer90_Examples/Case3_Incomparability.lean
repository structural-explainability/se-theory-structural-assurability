/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer60_Theorems
public import SE.StructuralAssurability.Layer90_Examples.Architectures
namespace SE.StructuralAssurability
/-- Evidence classes used by the incomparability example. -/
public inductive Case3Evidence where
  | internalTrace
  | independentActionRecord
  deriving DecidableEq, Repr
/-- Evidentiary capabilities used by the incomparability example. -/
public inductive Case3Capability where
  | examineInternalProcess
  | independentlyAttributeAction
  deriving DecidableEq, Repr
/-- Claim used by the incomparability example. -/
public def case3Claim : Claim Unit where
  holds := fun _ => True
/-- Evaluator conditions used by the incomparability example. -/
public def case3Conditions :
    EvaluatorConditions Unit Unit Unit Unit Unit where
  evaluator := ()
  knowledge := ()
  access := ()
  trust := ()
  cooperation := ()
/-- Comparative assurance context used by the incomparability example. -/
public def case3Context :
    ComparativeContext Unit Unit Unit Unit Unit Unit Unit where
  claim := case3Claim
  conditions := case3Conditions
  budget := ()
/--
The internal-visibility architecture exposes internal execution evidence but
not independent external evidence.
The independent-evidence architecture exposes independently generated
external-action evidence but little internal execution evidence.
-/
public def case3Access :
    EvidenceAccessModel
      RepresentativeArchitecture
      Case3Evidence
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessible := fun system _ evidence =>
    match system with
    | .internalVisibility =>
        evidence = .internalTrace
    | .independentEvidence =>
        evidence = .independentActionRecord
    | .opaqueService =>
        False
    | .instrumentedAgent =>
        False
    | .assurabilityOriented =>
        False
/-- Resource model used by the incomparability example. -/
public def case3Resources :
    ResourceModel RepresentativeArchitecture Case3Evidence Unit where
  feasible := fun _ _ _ => True
/-- Materiality standard used by the incomparability example. -/
public def case3Materiality :
    MaterialityStandard Unit Case3Evidence where
  material := fun _ _ => True
/-- Capability model used by the incomparability example. -/
public def case3CapabilityModel :
    CapabilityModel Unit Case3Evidence Case3Capability where
  enabled := fun _ evidenceSet capability =>
    match capability with
    | .examineInternalProcess =>
        Case3Evidence.internalTrace ∈ evidenceSet
    | .independentlyAttributeAction =>
        Case3Evidence.independentActionRecord ∈ evidenceSet
/-- Structural Assurability model used by the incomparability example. -/
public def case3Model :
    AssurabilityModel
      RepresentativeArchitecture
      Unit
      Case3Evidence
      Case3Capability
      Unit
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessModel := case3Access
  resourceModel := case3Resources
  materiality := case3Materiality
  capabilityModel := case3CapabilityModel
/-- Expected capability profile for each architecture in the incomparability example. -/
public abbrev case3ExpectedProfile
    (system : RepresentativeArchitecture) :
    Set Case3Capability :=
  { capability |
    match system with
    | .internalVisibility =>
        capability = .examineInternalProcess
    | .independentEvidence =>
        capability = .independentlyAttributeAction
    | .opaqueService =>
        False
    | .instrumentedAgent =>
        False
    | .assurabilityOriented =>
        False }
public theorem case3_profile_eq
    (system : RepresentativeArchitecture) :
    structuralAssurability case3Model system case3Context =
      case3ExpectedProfile system := by
  ext capability
  cases system <;>
    cases capability <;>
    simp [
      structuralAssurability,
      AssurabilityModel.profile,
      CapabilityModel.systemCapabilities,
      CapabilityModel.capabilities,
      MaterialityStandard.claimMaterialEvidence,
      EvidenceAccessModel.obtainableEvidence,
      case3Model,
      case3Access,
      case3Resources,
      case3Materiality,
      case3CapabilityModel,
      case3ExpectedProfile
    ]
/--
The internal-visibility architecture and independent-evidence architecture
are incomparable for this assurance context.
Each enables a claim-material capability unavailable from the other.
-/
public theorem case3_architectures_incomparable :
    assurabilityIncomparable
      case3Model
      case3Context
      .internalVisibility
      .independentEvidence := by
  constructor
  · intro internalGeIndependent
    have inIndependent :
        Case3Capability.independentlyAttributeAction ∈
          structuralAssurability
            case3Model
            .independentEvidence
            case3Context := by
      rw [case3_profile_eq]
      simp [case3ExpectedProfile]
    have inInternal :=
      internalGeIndependent inIndependent
    rw [case3_profile_eq] at inInternal
    simp [case3ExpectedProfile] at inInternal
  · intro independentGeInternal
    have inInternal :
        Case3Capability.examineInternalProcess ∈
          structuralAssurability
            case3Model
            .internalVisibility
            case3Context := by
      rw [case3_profile_eq]
      simp [case3ExpectedProfile]
    have inIndependent :=
      independentGeInternal inInternal
    rw [case3_profile_eq] at inIndependent
    simp [case3ExpectedProfile] at inIndependent
/--
The incomparability result is symmetric.
-/
public theorem case3_architectures_incomparable_reverse :
    assurabilityIncomparable
      case3Model
      case3Context
      .independentEvidence
      .internalVisibility :=
  assurabilityIncomparable_symm
    case3Model
    case3Context
    case3_architectures_incomparable
end SE.StructuralAssurability
