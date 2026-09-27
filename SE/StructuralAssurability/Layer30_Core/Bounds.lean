/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer20_Semantics.Indistinguishability
namespace SE.StructuralAssurability
universe uWorld uObservation
/--
A claim is resolved by an observation model over a world space when every
pair of admissible worlds that the model cannot distinguish agrees on the
truth of the claim.

Equivalently, observational indistinguishability must refine
claim-equivalence over the admissible world space.
-/
public abbrev claimResolvedBy
    {World : Type uWorld}
    {Observation : Type uObservation}
    (worldSpace : WorldSpace World)
    (model : ObservationModel World Observation)
    (claim : Claim World) :
    Prop :=
  ∀ {left right : World},
    worldSpace.admissible left →
    worldSpace.admissible right →
    indistinguishable model left right →
    (claim left ↔ claim right)
/--
A concrete witness that an observation model cannot resolve a claim over the
specified world space.

The witness consists of two admissible worlds that:

1. produce indistinguishable observations; and
2. disagree on the claim.
-/
public structure ResolutionFailureWitness
    {World : Type uWorld}
    {Observation : Type uObservation}
    (worldSpace : WorldSpace World)
    (model : ObservationModel World Observation)
    (claim : Claim World) where
  /-- Admissible world in which the first side of the resolution failure occurs. -/
  left : World
  /-- Admissible world in which the second side of the resolution failure occurs. -/
  right : World
  leftAdmissible : worldSpace.admissible left
  rightAdmissible : worldSpace.admissible right
  sameObservation : indistinguishable model left right
  claimDisagrees : claimDisagreement claim left right
/--
An admissible indistinguishable pair that disagrees on a claim is sufficient
to show that the observation model does not resolve that claim.

This is the core indistinguishability bound underlying later Structural
Assurability impossibility results.
-/
public theorem not_claimResolvedBy_of_witness
    {World : Type uWorld}
    {Observation : Type uObservation}
    {worldSpace : WorldSpace World}
    {model : ObservationModel World Observation}
    {claim : Claim World}
    (witness :
      ResolutionFailureWitness
        worldSpace
        model
        claim) :
    ¬ claimResolvedBy worldSpace model claim := by
  intro resolved
  have agrees :
      claim witness.left ↔ claim witness.right :=
    resolved
      witness.leftAdmissible
      witness.rightAdmissible
      witness.sameObservation
  exact witness.claimDisagrees agrees
/--
Direct form of the indistinguishability bound.

If two admissible worlds are observationally indistinguishable and disagree
on the claim, the observation model cannot resolve the claim.
-/
public theorem not_claimResolvedBy_of_indistinguishable_disagreement
    {World : Type uWorld}
    {Observation : Type uObservation}
    {worldSpace : WorldSpace World}
    {model : ObservationModel World Observation}
    {claim : Claim World}
    {left right : World}
    (leftAdmissible : worldSpace.admissible left)
    (rightAdmissible : worldSpace.admissible right)
    (sameObservation : indistinguishable model left right)
    (claimDisagrees : claimDisagreement claim left right) :
    ¬ claimResolvedBy worldSpace model claim := by
  apply not_claimResolvedBy_of_witness
  exact {
    left := left
    right := right
    leftAdmissible := leftAdmissible
    rightAdmissible := rightAdmissible
    sameObservation := sameObservation
    claimDisagrees := claimDisagrees
  }
end SE.StructuralAssurability
