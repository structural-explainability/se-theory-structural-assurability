/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
namespace SE.StructuralAssurability
/--
Simplified architecture classes used by the representative examples.
The first three correspond to the manuscript's opaque service,
instrumented agent, and assurability-oriented architectures.
The final two support the incomparability construction contrasting internal
visibility with independently generated external evidence.
-/
public inductive RepresentativeArchitecture where
  | opaqueService
  | instrumentedAgent
  | assurabilityOriented
  | internalVisibility
  | independentEvidence
  deriving DecidableEq, Repr
end SE.StructuralAssurability
