/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer10_Foundation.World
public import SE.StructuralAssurability.Layer10_Foundation.Claim
public import SE.StructuralAssurability.Layer20_Semantics.Observation
namespace SE.StructuralAssurability
universe uWorld uObservation
/--
Two worlds are indistinguishable under an observation model when the model
produces the same observation for both worlds.

The worlds themselves need not be equal.
-/
public abbrev indistinguishable
    {World : Type uWorld}
    {Observation : Type uObservation}
    (model : ObservationModel World Observation)
    (left right : World) :
    Prop :=
  model.observe left = model.observe right
/--
Two worlds disagree with respect to a claim when the claim has different
truth values in the two worlds.
-/
public abbrev claimDisagreement
    {World : Type uWorld}
    (claim : Claim World)
    (left right : World) :
    Prop :=
  ¬ (claim left ↔ claim right)
/--
Two worlds are admissibly indistinguishable when both worlds belong to the
stated world space and the observation model cannot distinguish them.

This definition will support later impossibility results: if two admissible
worlds disagree on a claim but remain indistinguishable under obtainable
observations, the evaluator lacks a claim-resolving distinction under those
conditions.
-/
public abbrev admissiblyIndistinguishable
    {World : Type uWorld}
    {Observation : Type uObservation}
    (worldSpace : WorldSpace World)
    (model : ObservationModel World Observation)
    (left right : World) :
    Prop :=
  worldSpace.admissible left ∧
  worldSpace.admissible right ∧
  indistinguishable model left right
end SE.StructuralAssurability
