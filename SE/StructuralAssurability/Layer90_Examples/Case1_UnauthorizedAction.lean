/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer30_Core.Bounds
public import SE.StructuralAssurability.Layer60_Theorems
public import SE.StructuralAssurability.Layer90_Examples.Architectures
namespace SE.StructuralAssurability
/--
Evidence classes used in the unauthorized-consequential-action example.
-/
public inductive Case1Evidence where
  | occurrence
  | origin
  | authorization
  | pathway
  | integrity
  | coverage
  | independentCorroboration
  deriving DecidableEq, Repr
/--
Evidentiary capabilities used in the unauthorized-consequential-action
example.
-/
public inductive Case1Capability where
  | establishOccurrence
  | establishOrigin
  | establishAuthorization
  | reconstructPathway
  | detectEvidenceManipulation
  | examineActionSurface
  | corroborateIndependently
  deriving DecidableEq, Repr
/--
The comparative claim is abstract in this example because the ordering is
determined by the evidence capabilities available for evaluating it.
-/
public def case1Claim : Claim Unit where
  holds := fun _ => True
/-- Evaluator conditions used by the unauthorized-action example. -/
public def case1Conditions :
    EvaluatorConditions Unit Unit Unit Unit Unit where
  evaluator := ()
  knowledge := ()
  access := ()
  trust := ()
  cooperation := ()
/-- Comparative context used by the unauthorized-action example. -/
public def case1Context :
    ComparativeContext Unit Unit Unit Unit Unit Unit Unit where
  claim := case1Claim
  conditions := case1Conditions
  budget := ()
/--
The opaque service exposes only occurrence evidence.
The instrumented agent additionally exposes origin, authorization, and
execution-path evidence.
The assurability-oriented architecture preserves those surfaces and adds
integrity, coverage, and independent-corroboration evidence.
-/
public def case1Access :
    EvidenceAccessModel
      RepresentativeArchitecture
      Case1Evidence
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessible := fun system _ evidence =>
    match system with
    | .opaqueService =>
        evidence = .occurrence
    | .instrumentedAgent =>
        evidence = .occurrence ∨
        evidence = .origin ∨
        evidence = .authorization ∨
        evidence = .pathway
    | .assurabilityOriented =>
        True
    | .internalVisibility =>
        False
    | .independentEvidence =>
        False
/-- Resource model used by the unauthorized-action example. -/
public def case1Resources :
    ResourceModel RepresentativeArchitecture Case1Evidence Unit where
  feasible := fun _ _ _ => True
/-- Materiality standard used by the unauthorized-action example. -/
public def case1Materiality :
    MaterialityStandard Unit Case1Evidence where
  material := fun _ _ => True
/--
Each capability in this simplified construction is enabled by its
corresponding evidence class.
-/
public def case1CapabilityModel :
    CapabilityModel Unit Case1Evidence Case1Capability where
  enabled := fun _ evidenceSet capability =>
    match capability with
    | .establishOccurrence =>
        Case1Evidence.occurrence ∈ evidenceSet
    | .establishOrigin =>
        Case1Evidence.origin ∈ evidenceSet
    | .establishAuthorization =>
        Case1Evidence.authorization ∈ evidenceSet
    | .reconstructPathway =>
        Case1Evidence.pathway ∈ evidenceSet
    | .detectEvidenceManipulation =>
        Case1Evidence.integrity ∈ evidenceSet
    | .examineActionSurface =>
        Case1Evidence.coverage ∈ evidenceSet
    | .corroborateIndependently =>
        Case1Evidence.independentCorroboration ∈ evidenceSet
/-- Structural Assurability model used by the unauthorized-action example. -/
public def case1Model :
    AssurabilityModel
      RepresentativeArchitecture
      Unit
      Case1Evidence
      Case1Capability
      Unit
      Unit
      Unit
      Unit
      Unit
      Unit where
  accessModel := case1Access
  resourceModel := case1Resources
  materiality := case1Materiality
  capabilityModel := case1CapabilityModel
/--
Expected capability profile for each representative architecture in Case 1.
-/
public abbrev case1ExpectedProfile
    (system : RepresentativeArchitecture) :
    Set Case1Capability :=
  { capability |
    match system with
    | .opaqueService =>
        capability = .establishOccurrence
    | .instrumentedAgent =>
        capability = .establishOccurrence ∨
        capability = .establishOrigin ∨
        capability = .establishAuthorization ∨
        capability = .reconstructPathway
    | .assurabilityOriented =>
        True
    | .internalVisibility =>
        False
    | .independentEvidence =>
        False }
/--
The formal Structural Assurability profile agrees with the intended
architecture profile for Case 1.
-/
public theorem case1_profile_eq
    (system : RepresentativeArchitecture) :
    structuralAssurability case1Model system case1Context =
      case1ExpectedProfile system := by
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
      case1Model,
      case1Access,
      case1Resources,
      case1Materiality,
      case1CapabilityModel,
      case1ExpectedProfile
    ]
public theorem case1_instrumented_preserves_opaque :
    atLeastAsAssurable
      case1Model
      case1Context
      .instrumentedAgent
      .opaqueService := by
  intro capability enabled
  rw [case1_profile_eq] at enabled ⊢
  cases capability <;>
    simp [case1ExpectedProfile] at enabled ⊢
public theorem case1_origin_additional :
    ∃ capability,
      capability ∈
        structuralAssurability
          case1Model
          .instrumentedAgent
          case1Context ∧
      capability ∉
        structuralAssurability
          case1Model
          .opaqueService
          case1Context := by
  refine ⟨Case1Capability.establishOrigin, ?_, ?_⟩
  · rw [case1_profile_eq]
    simp [case1ExpectedProfile]
  · rw [case1_profile_eq]
    simp [case1ExpectedProfile]
public theorem case1OpaqueToInstrumented :
    ConservativeExtensionWitness
      case1Model
      case1Context
      .opaqueService
      .instrumentedAgent where
  preserves := case1_instrumented_preserves_opaque
  additionalCapability := case1_origin_additional
/--
For the unauthorized-consequential-action context, the instrumented agent is
strictly more assurable than the opaque service.
-/
public theorem case1_instrumented_strict_opaque :
    strictlyMoreAssurable
      case1Model
      case1Context
      .instrumentedAgent
      .opaqueService :=
  conservativeExtension_strictlyMoreAssurable
    case1Model
    case1Context
    case1OpaqueToInstrumented
public theorem case1_oriented_preserves_instrumented :
    atLeastAsAssurable
      case1Model
      case1Context
      .assurabilityOriented
      .instrumentedAgent := by
  intro capability enabled
  rw [case1_profile_eq] at enabled ⊢
  cases capability <;>
    simp [case1ExpectedProfile] at enabled ⊢
public theorem case1_integrity_additional :
    ∃ capability,
      capability ∈
        structuralAssurability
          case1Model
          .assurabilityOriented
          case1Context ∧
      capability ∉
        structuralAssurability
          case1Model
          .instrumentedAgent
          case1Context := by
  refine ⟨Case1Capability.detectEvidenceManipulation, ?_, ?_⟩
  · rw [case1_profile_eq]
    simp [case1ExpectedProfile]
  · rw [case1_profile_eq]
    simp [case1ExpectedProfile]
public theorem case1InstrumentedToOriented :
    ConservativeExtensionWitness
      case1Model
      case1Context
      .instrumentedAgent
      .assurabilityOriented where
  preserves := case1_oriented_preserves_instrumented
  additionalCapability := case1_integrity_additional
/--
For the same context, the assurability-oriented architecture is strictly
more assurable than the instrumented agent.
-/
public theorem case1_oriented_strict_instrumented :
    strictlyMoreAssurable
      case1Model
      case1Context
      .assurabilityOriented
      .instrumentedAgent :=
  conservativeExtension_strictlyMoreAssurable
    case1Model
    case1Context
    case1InstrumentedToOriented
/--
Possible worlds used to illustrate the resolution bound for an opaque
observation surface.
-/
public inductive Case1World where
  | noUnauthorizedAction
  | unauthorizedAction
  deriving DecidableEq, Repr
/-- Claim used by the unauthorized-action resolution-bound example. -/
public def case1NoUnauthorizedActionClaim :
    Claim Case1World where
  holds := fun world =>
    world = .noUnauthorizedAction
/--
An opaque observation surface that exposes no distinction between the two
claim-relevant worlds.
-/
public def case1OpaqueObservation :
    ObservationModel Case1World Unit where
  observe := fun _ => ()
/--
Because the opaque observation surface maps a world with no unauthorized
action and a world with an unauthorized action to the same observation, it
cannot resolve the claim over the unrestricted world space.

Explicit:
claim(noUnauthorizedAction) = true
claim(unauthorizedAction)   = false
-/
public theorem case1_opaque_observation_not_resolving :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted Case1World)
      case1OpaqueObservation
      case1NoUnauthorizedActionClaim := by
  apply not_claimResolvedBy_of_indistinguishable_disagreement
    (left := Case1World.noUnauthorizedAction)
    (right := Case1World.unauthorizedAction)
  · trivial
  · trivial
  · rfl
  · change ¬ (
    (Case1World.noUnauthorizedAction =
      Case1World.noUnauthorizedAction) ↔
    (Case1World.unauthorizedAction =
      Case1World.noUnauthorizedAction)
    )
    simp
end SE.StructuralAssurability
