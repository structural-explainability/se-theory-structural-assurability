/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer60_Theorems.ObservabilitySeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.CoverageSeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.TraceabilitySeparatingConstruction
public import SE.StructuralAssurability.Layer60_Theorems.ReconstructabilitySeparatingConstruction

namespace SETest.StructuralAssurability.FourDimensionSeparatingConstructionRegression

open SE.StructuralAssurability

/-!
# Combined regression tests for four structural dimensions

Tests the dimension-specific separating constructions for observability,
evidence coverage, traceability, and reconstructability.

Uses a finite Boolean system model with independently established
Structural Assurability non-equivalence.

The tests cover positive constructions, controlled coverage,
representative cross-dimension rejection, and the remaining
unrestricted behavior of the generic separating-construction interface.
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

theorem not_equivalent : ¬ assurabilityEquivalent assurabilityModel context false true := by
  intro h
  have hmem : ((() : Unit) ∈ AssurabilityModel.profile assurabilityModel true context) :=
    (profile_iff true).mpr rfl
  rw [show AssurabilityModel.profile assurabilityModel true context =
        AssurabilityModel.profile assurabilityModel false context from h.symm] at hmem
  exact absurd ((profile_iff false).mp hmem) (by decide)

/-! ## Positive constructions for coverage, traceability, and reconstructability -/

def covModel : EvidenceCoverageModel Bool Unit where
  covered := fun s _ => s = true

theorem covProfile_iff (s : Bool) :
    ((() : Unit) ∈ EvidenceCoverageModel.profile covModel s) ↔ s = true := Iff.rfl

theorem covProfile_controlled :
    ¬ covModel.covered false () ∧ covModel.covered true () ∧
      ∀ element, element ≠ () →
        (covModel.covered false element ↔ covModel.covered true element) :=
  ⟨fun h => absurd ((covProfile_iff false).mp h) (by decide),
   (covProfile_iff true).mpr rfl,
   fun element h => absurd (by cases element; rfl) h⟩

theorem covProfile_false_ssubset_true :
    EvidenceCoverageModel.profile covModel false ⊂ EvidenceCoverageModel.profile covModel true := by
  constructor
  · intro a ha; exact absurd ((covProfile_iff false).mp ha) (by decide)
  · intro h
    exact absurd ((covProfile_iff false).mp (h ((covProfile_iff true).mpr rfl))) (by decide)

example : assuranceRelevantDimension
    assurabilityModel (coverageDifference covModel) .evidenceCoverage :=
  evidenceCoverage_assuranceRelevant_of_profile_difference
    assurabilityModel covModel context false true
    covProfile_false_ssubset_true not_equivalent

-- the controlled form also certifies relevance, via the implication theorem
example : coverageDifference covModel .evidenceCoverage false true :=
  coverageControlledDifference_imp_coverageDifference covModel () covProfile_controlled

/-! ## Controlled coverage with two distinct elements -/

-- The focal element is uncovered in the lower system and covered
-- in the upper system. The non-focal element is covered in both.
def covTwoElementModel : EvidenceCoverageModel Bool Bool where
  covered := fun s element => s = true ∨ element = true

-- Both systems cover the non-focal element.
example :
    covTwoElementModel.covered false true ∧
      covTwoElementModel.covered true true := by
  simp [covTwoElementModel]

-- The focal coverage difference satisfies the controlled relation,
-- including its non-focal agreement obligation.
theorem covTwoElementControlled :
    coverageControlledDifference
      covTwoElementModel false .evidenceCoverage false true := by
  refine ⟨by simp [covTwoElementModel], by simp [covTwoElementModel], ?_⟩
  intro element h
  cases element with
  | false => exact False.elim (h rfl)
  | true => simp [covTwoElementModel]

-- The controlled difference establishes general profile inclusion.
example :
    coverageDifference covTwoElementModel .evidenceCoverage false true :=
  coverageControlledDifference_imp_coverageDifference
    covTwoElementModel false covTwoElementControlled

/-! ## Controlled coverage rejects additional differences -/

-- Both coverage elements now differ between the two systems.
def covTwoElementExtraChangeModel : EvidenceCoverageModel Bool Bool where
  covered := fun s _ => s = true

theorem covTwoElementExtraChangeProfile_iff (s element : Bool) :
    element ∈ EvidenceCoverageModel.profile covTwoElementExtraChangeModel s ↔
      s = true := Iff.rfl

-- General profile inclusion permits differences in multiple elements.
example :
    coverageDifference
      covTwoElementExtraChangeModel .evidenceCoverage false true := by
  constructor
  · intro element _
    exact (covTwoElementExtraChangeProfile_iff true element).mpr rfl
  · intro h
    have hUpper :
        (false : Bool) ∈
          EvidenceCoverageModel.profile covTwoElementExtraChangeModel true :=
      (covTwoElementExtraChangeProfile_iff true false).mpr rfl
    have hLower := h hUpper
    exact absurd
      ((covTwoElementExtraChangeProfile_iff false false).mp hLower)
      (by decide)

-- The controlled relation rejects the additional non-focal difference.
example :
    ¬ coverageControlledDifference
      covTwoElementExtraChangeModel false .evidenceCoverage false true := by
  intro h
  have hAgreement := h.2.2 true (by decide)
  have hUpper : covTwoElementExtraChangeModel.covered true true := by
    simp [covTwoElementExtraChangeModel]
  have hLower : covTwoElementExtraChangeModel.covered false true :=
    hAgreement.mpr hUpper
  simp [covTwoElementExtraChangeModel] at hLower

-- Evidence type matches assurabilityModel's Evidence (Bool); a fixed
-- evidence value is chosen for the fixed-evidence-item construction.
def traceModel : TraceabilityModel Bool Bool Unit where
  traceable := fun s _ _ => s = true

theorem traceProfile_iff (e : Bool) (s : Bool) :
    ((() : Unit) ∈ TraceabilityModel.targets traceModel s e) ↔ s = true := Iff.rfl

theorem traceProfile_false_ssubset_true :
    TraceabilityModel.targets traceModel false true ⊂
      TraceabilityModel.targets traceModel true true := by
  constructor
  · intro a ha; exact absurd ((traceProfile_iff true false).mp ha) (by decide)
  · intro h
    exact absurd ((traceProfile_iff true false).mp
      (h ((traceProfile_iff true true).mpr rfl))) (by decide)

example : assuranceRelevantDimension
    assurabilityModel (traceabilityDifference traceModel true) .traceability :=
  traceability_assuranceRelevant_of_profile_difference
    assurabilityModel traceModel true context false true
    traceProfile_false_ssubset_true not_equivalent

def reconModel : ReconstructabilityModel Bool Unit where
  reconstructable := fun s _ => s = true

theorem reconProfile_iff (s : Bool) :
    ((() : Unit) ∈ ReconstructabilityModel.profile reconModel s) ↔ s = true := Iff.rfl

theorem reconProfile_false_ssubset_true :
    ReconstructabilityModel.profile reconModel false ⊂
      ReconstructabilityModel.profile reconModel true := by
  constructor
  · intro a ha; exact absurd ((reconProfile_iff false).mp ha) (by decide)
  · intro h
    exact absurd ((reconProfile_iff false).mp
      (h ((reconProfile_iff true).mpr rfl))) (by decide)

example : assuranceRelevantDimension
    assurabilityModel (reconstructabilityDifference reconModel) .reconstructability :=
  reconstructability_assuranceRelevant_of_profile_difference
    assurabilityModel reconModel context false true
    reconProfile_false_ssubset_true not_equivalent

/-!
## Negative regression: unrestricted and dimension-locked constructions

The generic `SeparatingConstruction` interface permits arbitrary
difference relations. A vacuous relation can attribute the same
genuine assurability difference to all seven candidate dimensions
without establishing the corresponding structural-property differences.

Each dimension-specific relation restricts attribution to its
designated dimension. The isolation theorems establish this
restriction generally, while the regression examples exercise
representative cross-dimension cases.

These restrictions do not establish that the structural properties
are mutually independent.
-/

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

-- The unrestricted generic interface still accepts the vacuous relation.
-- The same genuine assurability difference can consequently be attributed
-- to all seven dimensions without grounding those attributions in their
-- corresponding structural-property models.
example :
    assuranceRelevantDimension assurabilityModel vacuousDifference .observability ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .evidenceCoverage ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .traceability ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .reconstructability ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .independence ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .integrity ∧
    assuranceRelevantDimension assurabilityModel vacuousDifference .controllability :=
  ⟨separatingConstruction_establishes_relevance _ _ (vacuousConstruction .observability),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .evidenceCoverage),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .traceability),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .reconstructability),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .independence),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .integrity),
   separatingConstruction_establishes_relevance _ _ (vacuousConstruction .controllability)⟩

-- Each dimension-specific relation excludes attribution to every other
-- dimension. The isolation theorems establish this generally; the
-- following examples exercise representative cross-dimension cases.
example (h : coverageDifference covModel .traceability false true) : False :=
  absurd (coverageDifference_only_evidenceCoverage covModel h) (by decide)

example (h : traceabilityDifference traceModel true .reconstructability false true) : False :=
  absurd (traceabilityDifference_only_traceability traceModel true h) (by decide)

example (h : reconstructabilityDifference reconModel .observability false true) : False :=
  absurd (reconstructabilityDifference_only_reconstructability reconModel h) (by decide)

def crossCheckObsModel : ObservabilityModel Bool Unit where
  observable := fun s _ => s = true

example (h : observabilityDifference crossCheckObsModel .evidenceCoverage false true) : False :=
  absurd (observabilityDifference_only_observability crossCheckObsModel h) (by decide)

/-! ## Generic separating-construction theorem -/

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

end FourDimensionSeparatingConstructionRegression
end StructuralAssurability
end SETest
