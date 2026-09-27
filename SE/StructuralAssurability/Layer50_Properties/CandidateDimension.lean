/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import Mathlib.Data.Set.Basic
namespace SE.StructuralAssurability
universe uFeature
/--
The current provisional candidate structural dimensions.
The constructors enumerate the dimensions presently represented by the
theory. They do not assert that these dimensions exhaust all
assurance-relevant structural properties.
-/
public inductive CandidateStructuralDimension where
  | observability
  | controllability
  | traceability
  | reconstructability
  | independence
  | integrity
  | evidenceCoverage
  deriving DecidableEq, Repr
/--
An extensional profile for a structural dimension.
A profile records which features a system supports. It is a set rather than
a scalar measurement and therefore does not impose a numerical scale.
-/
public abbrev DimensionProfile (Feature : Type uFeature) :=
  Set Feature
end SE.StructuralAssurability
