/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer60_Theorems.ObservabilitySeparatingConstruction

namespace SETest.StructuralAssurability.ObservabilitySeparatingConstructionRegression

open SE.StructuralAssurability

/-!
# Observability separating-construction regression tests

Uses a Boolean system model in which the `false` system has an empty
assurability profile and the `true` system has a singleton profile.

A separate observability model assigns the same profile ordering
to observable features.

The tests demonstrate the unrestricted generic construction,
cross-dimension rejection by the observability-specific relation,
and a valid construction using independently established
observability-profile inclusion and assurability non-equivalence.

They do not establish a general relationship between
observability and evidentiary capability or claim resolution.
-/

def capModel : CapabilityModel Bool Bool Unit where
  enabled := fun _ E _ => E true

def accessModel : EvidenceAccessModel Bool Bool Unit Unit Unit Unit Unit where
  accessible := fun s _ e => e = s

def resourceModel : ResourceModel Bool Bool Unit where
  feasible := fun _ _ _ => True

def materiality : MaterialityStandard Bool Bool where
  material := fun _ _ => True

def assurabilityModel :
    AssurabilityModel Bool Bool Bool Unit Unit Unit Unit Unit Unit Unit where
  accessModel := accessModel
  resourceModel := resourceModel
  materiality := materiality
  capabilityModel := capModel

def context : ComparativeContext Bool Unit Unit Unit Unit Unit Unit where
  claim := { holds := fun _ => True }
  conditions := { evaluator := (), knowledge := (), access := (), trust := (), cooperation := () }
  budget := ()

theorem profile_iff (s : Bool) :
    ((() : Unit) ∈ AssurabilityModel.profile assurabilityModel s context) ↔
      true = s := by
  constructor
  · rintro ⟨⟨h, -⟩, -⟩; exact h
  · intro h; exact ⟨⟨h, trivial⟩, trivial⟩

theorem profile_false_ssubset_true :
    AssurabilityModel.profile assurabilityModel false context ⊂
      AssurabilityModel.profile assurabilityModel true context := by
  constructor
  · intro a ha
    exact absurd ((profile_iff false).mp ha) (by decide)
  · intro h
    exact absurd ((profile_iff false).mp (h ((profile_iff true).mpr rfl))) (by decide)

theorem not_equivalent : ¬ assurabilityEquivalent assurabilityModel context false true := by
  intro h
  have hmem : ((() : Unit) ∈ AssurabilityModel.profile assurabilityModel true context) :=
    (profile_iff true).mpr rfl
  rw [show AssurabilityModel.profile assurabilityModel true context =
        AssurabilityModel.profile assurabilityModel false context from h.symm] at hmem
  exact absurd ((profile_iff false).mp hmem) (by decide)

/-! ## 1. The generic interface remains unrestricted -/

-- The arbitrary, unconnected relation. It does not mention `dimension` at
-- all: it is `True` for every dimension given this one pair.
def vacuousDifference : CandidateStructuralDimension → Bool → Bool → Prop :=
  fun _ _ _ => True

def vacuousConstruction (d : CandidateStructuralDimension) :
    SeparatingConstruction assurabilityModel vacuousDifference where
  dimension := d
  context := context
  lower := false
  upper := true
  dimensionDiffers := trivial
  notEquivalent := not_equivalent

-- The unrestricted generic interface permits the same genuine
-- assurability difference to establish relevance for arbitrarily
-- selected dimensions when supplied with a vacuous difference relation.
-- These attributions are not grounded in the corresponding
-- structural-property models.
example :
    assuranceRelevantDimension assurabilityModel vacuousDifference .observability ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .controllability ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .integrity :=
  ⟨separatingConstruction_establishes_relevance _ _ (vacuousConstruction .observability),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .controllability),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .integrity)⟩

/-! ## 2. The observability relation prevents cross-dimension attribution -/

def obsModel : ObservabilityModel Bool Unit where
  observable := fun s _ => s = true

-- An observability difference cannot be attributed to controllability.
-- The isolation theorem requires the declared dimension to equal
-- `.observability`, so the required difference proof is impossible.
example (h : observabilityDifference obsModel .controllability false true) : False :=
  absurd (observabilityDifference_only_observability obsModel h) (by decide)

/-! ## 3. A profile-grounded observability construction is accepted -/

theorem obsProfile_iff (s : Bool) :
    ((() : Unit) ∈ ObservabilityModel.profile obsModel s) ↔ s = true := Iff.rfl

theorem obsProfile_false_ssubset_true :
    ObservabilityModel.profile obsModel false ⊂ ObservabilityModel.profile obsModel true := by
  constructor
  · intro a ha
    exact absurd ((obsProfile_iff false).mp ha) (by decide)
  · intro h
    exact absurd ((obsProfile_iff false).mp (h ((obsProfile_iff true).mpr rfl))) (by decide)

example : assuranceRelevantDimension
    assurabilityModel (observabilityDifference obsModel) .observability :=
  observability_assuranceRelevant_of_profile_difference
    assurabilityModel obsModel context false true
    obsProfile_false_ssubset_true
    not_equivalent

/-! ## 4. Generic separating-construction theorem -/

-- Verify that the generic relevance theorem remains applicable
-- to an arbitrary supplied separating construction.
example
    {System World Evidence Capability Evaluator Knowledge Access Trust
      Cooperation Budget : Type}
    (model :
      AssurabilityModel System World Evidence Capability Evaluator Knowledge
        Access Trust Cooperation Budget)
    (difference : CandidateStructuralDimension → System → System → Prop)
    (construction : SeparatingConstruction model difference) :
    assuranceRelevantDimension model difference construction.dimension :=
  separatingConstruction_establishes_relevance model difference construction

end SETest.StructuralAssurability.ObservabilitySeparatingConstructionRegression
