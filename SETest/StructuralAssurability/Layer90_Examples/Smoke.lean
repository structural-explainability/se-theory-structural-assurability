/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
import SE.StructuralAssurability.Layer90_Examples
namespace SETest.StructuralAssurability.Layer90_Examples
open SE.StructuralAssurability
example :
    strictlyMoreAssurable
      case1Model
      case1Context
      .instrumentedAgent
      .opaqueService :=
  case1_instrumented_strict_opaque
example :
    strictlyMoreAssurable
      case1Model
      case1Context
      .assurabilityOriented
      .instrumentedAgent :=
  case1_oriented_strict_instrumented
example :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted Case1World)
      case1OpaqueObservation
      case1NoUnauthorizedActionClaim :=
  case1_opaque_observation_not_resolving
example :
    assurabilityEquivalent
      case2Model
      case2Context
      .opaqueService
      .instrumentedAgent :=
  case2_opaque_equivalent_instrumented
example :
    assurabilityEquivalent
      case2Model
      case2Context
      .opaqueService
      .assurabilityOriented :=
  case2_opaque_equivalent_oriented
example :
    assurabilityIncomparable
      case3Model
      case3Context
      .internalVisibility
      .independentEvidence :=
  case3_architectures_incomparable
end SETest.StructuralAssurability.Layer90_Examples
