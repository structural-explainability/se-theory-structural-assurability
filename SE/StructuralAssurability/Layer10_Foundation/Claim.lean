/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

namespace SE.StructuralAssurability

universe u

/--
An assurance `Claim` is a proposition whose truth may vary across possible
worlds.

Structural Assurability is claim-relative: the relevant evidence and
distinctions depend on the particular claim under evaluation.
-/
public structure Claim (World : Type u) where
  /-- Whether the claim holds in a world. -/
  holds : World → Prop

/--
Permit a claim to be applied directly to a world.
-/
public instance {World : Type u} :
    CoeFun (Claim World) (fun _ => World → Prop) where
  coe claim := claim.holds

end SE.StructuralAssurability
