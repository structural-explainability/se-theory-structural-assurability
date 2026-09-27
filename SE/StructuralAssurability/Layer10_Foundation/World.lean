/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

namespace SE.StructuralAssurability

universe u

/--
A `WorldSpace` identifies which possible worlds are admissible for an
assurance problem.

The carrier type `World` is intentionally unconstrained. Later semantic
layers may use worlds to represent system states, executions, histories,
system-environment configurations, or other alternatives relevant to a
claim.
-/
public structure WorldSpace (World : Type u) where
  /-- Whether a world is admitted for the current analysis. -/
  admissible : World → Prop

namespace WorldSpace

/--
The unrestricted world space in which every value of `World` is admissible.
-/
public abbrev unrestricted (World : Type u) : WorldSpace World where
  admissible := fun _ => True

end WorldSpace

end SE.StructuralAssurability
