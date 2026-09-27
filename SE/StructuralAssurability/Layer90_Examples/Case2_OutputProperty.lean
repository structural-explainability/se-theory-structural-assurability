/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer60_Theorems
public import SE.StructuralAssurability.Layer90_Examples.Architectures
namespace SE.StructuralAssurability
/-- Evidence classes used by the externally observable output example. -/
public inductive Case2Evidence where
  | externalOutput
  | internalTrace
  | protectedRecord
  deriving DecidableEq, Repr
/-- Evidentiary capability used by the externally observable output example. -/
public inductive Case2Capability where
  | classifyOutput
  deriving DecidableEq, Repr
/-- Claim used by the externally observable output example. -/
public def case2Claim : Claim Unit where
  holds := fun _ => True
/-- Evaluator conditions used by the externally observable output example. -/
public def case2Conditions :
    EvaluatorConditions Unit Unit Unit Unit Unit where
  evaluator := ()
  knowledge := ()
  access := ()
  trust := ()
  cooperation := ()
/-- Comparative assurance context used by the externally observable output example. -/
public def case2Context :
    ComparativeContext Unit Unit Unit Unit Unit Unit Unit where
  claim := case2Claim
  conditions := case2Conditions
  budget := ()
/--
All three manuscript architectures expose the externally returned output.
The more instrumented architectures expose additional evidence as well.
-/
public def case2Access :
    EvidenceAccessModel
      RepresentativeArchitecture
      Case2Evidence
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessible := fun system _ evidence =>
    match system with
    | .opaqueService =>
        evidence = .externalOutput
    | .instrumentedAgent =>
        evidence = .externalOutput ∨
        evidence = .internalTrace
    | .assurabilityOriented =>
        True
    | .internalVisibility =>
        False
    | .independentEvidence =>
        False
/-- Resource model used by the externally observable output example. -/
public def case2Resources :
    ResourceModel RepresentativeArchitecture Case2Evidence Unit where
  feasible := fun _ _ _ => True
/--
For this assurance claim, only the externally returned output is material.
Additional internal or protected evidence is outside the claim-material
evidence set.
-/
public def case2Materiality :
    MaterialityStandard Unit Case2Evidence where
  material := fun _ evidence =>
    evidence = .externalOutput
/-- Capability model used by the externally observable output example. -/
public def case2CapabilityModel :
    CapabilityModel Unit Case2Evidence Case2Capability where
  enabled := fun _ evidenceSet capability =>
    match capability with
    | .classifyOutput =>
        Case2Evidence.externalOutput ∈ evidenceSet
/-- Structural Assurability model used by the externally observable output example. -/
public def case2Model :
    AssurabilityModel
      RepresentativeArchitecture
      Unit
      Case2Evidence
      Case2Capability
      Unit
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessModel := case2Access
  resourceModel := case2Resources
  materiality := case2Materiality
  capabilityModel := case2CapabilityModel
/--
The opaque service and instrumented agent are assurability-equivalent for
this externally resolvable output claim.
-/
public theorem case2_opaque_equivalent_instrumented :
    assurabilityEquivalent
      case2Model
      case2Context
      .opaqueService
      .instrumentedAgent := by
  ext capability
  cases capability
  simp [
    structuralAssurability,
    AssurabilityModel.profile,
    CapabilityModel.systemCapabilities,
    CapabilityModel.capabilities,
    MaterialityStandard.claimMaterialEvidence,
    EvidenceAccessModel.obtainableEvidence,
    case2Model,
    case2Access,
    case2Resources,
    case2Materiality,
    case2CapabilityModel
  ]
/--
The instrumented agent and assurability-oriented architecture are likewise
equivalent for the same claim.
-/
public theorem case2_instrumented_equivalent_oriented :
    assurabilityEquivalent
      case2Model
      case2Context
      .instrumentedAgent
      .assurabilityOriented := by
  ext capability
  cases capability
  simp [
    structuralAssurability,
    AssurabilityModel.profile,
    CapabilityModel.systemCapabilities,
    CapabilityModel.capabilities,
    MaterialityStandard.claimMaterialEvidence,
    EvidenceAccessModel.obtainableEvidence,
    case2Model,
    case2Access,
    case2Resources,
    case2Materiality,
    case2CapabilityModel
  ]
/--
Consequently, the opaque service and assurability-oriented architecture are
also equivalent for this claim.
-/
public theorem case2_opaque_equivalent_oriented :
    assurabilityEquivalent
      case2Model
      case2Context
      .opaqueService
      .assurabilityOriented :=
  assurabilityEquivalent_trans
    case2Model
    case2Context
    case2_opaque_equivalent_instrumented
    case2_instrumented_equivalent_oriented
end SE.StructuralAssurability
