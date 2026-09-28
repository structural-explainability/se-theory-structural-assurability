/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer30_Core.Bounds
public import SE.StructuralAssurability.Layer30_Core.ApproximationTransfer

namespace SE.StructuralAssurability.PrecinctVintage

/-!
# Precinct-vintage example: claim-relative resolution

A finite toy model of the claim "this precinct dataset is current" under three
evidence surfaces:

* **A** a bare dataset snapshot (nothing observable);
* **B** a dataset with a self-reported vintage label;
* **C** a dataset with an independent check against a reference.

This file is an *example*. It establishes facts about a finite model whose
worlds and observation functions are defined here. It establishes nothing
about any actual precinct-data pipeline; see the assumption register below.

No capability profile, capability, or soundness predicate is used or added.

## Assumption register (each is a `WorldSpace` restriction, never built in)

- `HonestLabel`: the self-reported label equals the actual vintage.
- `KnownCurrent k`: the truly current vintage is the known value `k`.
- `IsAuthoritative`: the reference reports the vintage that was current when
  it was consulted (authority).
- `IsCurrentAtCheck`: the vintage current when the reference was consulted is
  still the current vintage now (currency).
- `CheckCorrect`: the check reports success exactly when the dataset's actual
  vintage equals the vintage the reference reports (verification correctness).

The reference is not assumed infallible or current: authority and currency
are separate, explicit, and each shows that dropping
any one of the three checker assumptions defeats
the stated universal resolution guarantee
over the corresponding enlarged world space.
They do **not** establish that those assumptions are necessary
for resolution in every possible observation model.


## Modeling limits

Vintages are two-valued. Worlds are finite. The observation of each surface
is *defined* here; whether it matches what a real evaluator sees is exactly
the observation-faithfulness question addressed in `ApproximationTransfer`.
-/

/-! ## Model -/

/-- Two dataset vintages. -/
public inductive Vintage where
  | v2024
  | v2025
  deriving DecidableEq, Repr

/-- An abstract world of the precinct-vintage example. -/
public structure VWorld where
  /-- The vintage the dataset actually is. -/
  actual : Vintage
  /-- The vintage the dataset's self-reported label states. -/
  label : Vintage
  /-- The vintage the reference reports as current. -/
  reference : Vintage
  /-- The vintage that was current when the reference was consulted. -/
  truthAtCheck : Vintage
  /-- The vintage that is current now. -/
  truth : Vintage
  /-- The result reported by the independent check. -/
  check : Bool

/-- The claim: the dataset's actual vintage is the currently current one. -/
public def currentClaim : Claim VWorld where
  holds := fun w => w.actual = w.truth

/-! ## Evidence surfaces -/

/-- A: bare snapshot. Nothing about vintage is observable. -/
public def surfaceA : ObservationModel VWorld Unit where
  observe := fun _ => ()

/-- B: the self-reported vintage label is observable. -/
public def surfaceB : ObservationModel VWorld Vintage where
  observe := fun w => w.label

/-- C: the result of the independent check is observable. -/
public def surfaceC : ObservationModel VWorld Bool where
  observe := fun w => w.check

/-! ## Assumption Predicates -/

/--
The dataset's self-reported vintage agrees with its actual vintage.

This assumption concerns the accuracy of the label, not whether the
dataset is current.
-/
public abbrev HonestLabel (w : VWorld) : Prop := w.label = w.actual

/--
The vintage currently in effect is the specified known value `k`.

This assumption does not establish that the dataset or its
self-reported label has that vintage.
-/
public abbrev KnownCurrent (k : Vintage) (w : VWorld) : Prop := w.truth = k

/--
The reference reports the vintage that was current when it was consulted.

Authority does not establish that the reference remains current at
the time the claim is evaluated.
-/
public abbrev IsAuthoritative (w : VWorld) : Prop :=
  w.reference = w.truthAtCheck

/--
The vintage current when the reference was consulted remains current
at the time the claim is evaluated.

This assumption connects the reference-checking time to the time
at which the assurance claim is evaluated.
-/
public abbrev IsCurrentAtCheck (w : VWorld) : Prop :=
  w.truthAtCheck = w.truth

/--
The independent check reports success exactly when the dataset's
actual vintage agrees with the reference's reported vintage.

Verification correctness does not independently establish reference
authority or currency.
-/
public abbrev CheckCorrect (w : VWorld) : Prop :=
  w.check = true ↔ w.actual = w.reference

/-- No labels or reference assumptions: every world is admissible. -/
public abbrev allWorlds : WorldSpace VWorld :=
  WorldSpace.unrestricted VWorld

/-- Only the current vintage is known; labels may be inaccurate. -/
public abbrev knownCurrentSpace (k : Vintage) : WorldSpace VWorld where
  admissible := fun w => KnownCurrent k w

/-- Only label honesty is assumed; the current vintage is not known. -/
public abbrev honestOnlySpace : WorldSpace VWorld where
  admissible := fun w => HonestLabel w

/-- Honest labels and a known current vintage. -/
public abbrev honestKnownSpace (k : Vintage) : WorldSpace VWorld where
  admissible := fun w => HonestLabel w ∧ KnownCurrent k w

/-- Reference authority, currency, and verification correctness. -/
public abbrev trustedCheckSpace : WorldSpace VWorld where
  admissible := fun w =>
    IsAuthoritative w ∧ IsCurrentAtCheck w ∧ CheckCorrect w

/-- Trusted check with the authority assumption dropped. -/
public abbrev noAuthoritySpace : WorldSpace VWorld where
  admissible := fun w => IsCurrentAtCheck w ∧ CheckCorrect w

/-- Trusted check with the currency assumption dropped. -/
public abbrev noCurrencySpace : WorldSpace VWorld where
  admissible := fun w => IsAuthoritative w ∧ CheckCorrect w

/-- Trusted check with the verification-correctness assumption dropped. -/
public abbrev noVerificationSpace : WorldSpace VWorld where
  admissible := fun w => IsAuthoritative w ∧ IsCurrentAtCheck w

/-- Every assumption at once, with current vintage `k`. -/
public abbrev fullyAssumedSpace (k : Vintage) : WorldSpace VWorld where
  admissible := fun w =>
    HonestLabel w ∧ KnownCurrent k w ∧
    IsAuthoritative w ∧ IsCurrentAtCheck w ∧ CheckCorrect w

/-! ## Witness worlds -/

/-- A dataset that is current, with every assumption satisfied. -/
public def wCurrent : VWorld where
  actual := .v2025
  label := .v2025
  reference := .v2025
  truthAtCheck := .v2025
  truth := .v2025
  check := true

/-- A stale dataset with an honest label, every assumption satisfied. -/
public def wStale : VWorld where
  actual := .v2024
  label := .v2024
  reference := .v2025
  truthAtCheck := .v2025
  truth := .v2025
  check := false

/-- A stale dataset carrying an inaccurate (current) label. -/
public def wStaleLying : VWorld where
  actual := .v2024
  label := .v2025
  reference := .v2025
  truthAtCheck := .v2025
  truth := .v2025
  check := false

/-- Honest label, but a different current vintage (unknown to the evaluator). -/
public def wStaleHonestMoved : VWorld where
  actual := .v2025
  label := .v2025
  reference := .v2025
  truthAtCheck := .v2025
  truth := .v2024
  check := true

/-- Check passes against a wrong reference (authority fails). -/
public def wWrongReference : VWorld where
  actual := .v2024
  label := .v2024
  reference := .v2024
  truthAtCheck := .v2025
  truth := .v2025
  check := true

/-- Check passes against a reference that was current, then superseded. -/
public def wSuperseded : VWorld where
  actual := .v2024
  label := .v2024
  reference := .v2024
  truthAtCheck := .v2024
  truth := .v2025
  check := true

/-- Check reports success although the dataset differs from the reference. -/
public def wFaultyCheck : VWorld where
  actual := .v2024
  label := .v2024
  reference := .v2025
  truthAtCheck := .v2025
  truth := .v2025
  check := true

/-! ## 1. Surface A cannot resolve the claim -/

/-- A fails on any world space admitting `wCurrent` and `wStale`. -/
public theorem surfaceA_unresolved_of_admissible
    {S : WorldSpace VWorld}
    (hc : S.admissible wCurrent) (hs : S.admissible wStale) :
    ¬ claimResolvedBy S surfaceA currentClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement hc hs rfl
    (by
      change ¬ (wCurrent.actual = wCurrent.truth ↔
        wStale.actual = wStale.truth)
      decide)

/-- A cannot resolve the claim with no assumptions. -/
public theorem surfaceA_unresolved :
    ¬ claimResolvedBy allWorlds surfaceA currentClaim :=
  surfaceA_unresolved_of_admissible trivial trivial

/-- A cannot resolve the claim even under every assumption at once. -/
public theorem surfaceA_unresolved_fully_assumed :
    ¬ claimResolvedBy (fullyAssumedSpace .v2025) surfaceA currentClaim :=
  surfaceA_unresolved_of_admissible (by decide) (by decide)

/-! ## 2. Surface B, inaccurate labels admissible -/

/-- B fails on any world space admitting `wCurrent` and `wStaleLying`. -/
public theorem surfaceB_unresolved_of_admissible_lying
    {S : WorldSpace VWorld}
    (hc : S.admissible wCurrent) (hl : S.admissible wStaleLying) :
    ¬ claimResolvedBy S surfaceB currentClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement hc hl rfl
    (by
      change ¬ (wCurrent.actual = wCurrent.truth ↔
        wStaleLying.actual = wStaleLying.truth)
      decide)

/-- B cannot resolve the claim when inaccurate labels are admissible. -/
public theorem surfaceB_unresolved_lying_labels :
    ¬ claimResolvedBy allWorlds surfaceB currentClaim :=
  surfaceB_unresolved_of_admissible_lying trivial trivial

/-- Knowing the current vintage does not help while labels may be wrong. -/
public theorem surfaceB_unresolved_known_current_lying_labels :
    ¬ claimResolvedBy (knownCurrentSpace .v2025) surfaceB currentClaim :=
  surfaceB_unresolved_of_admissible_lying (by decide) (by decide)

/-- Trusting the reference and check does not make the label trustworthy. -/
public theorem surfaceB_unresolved_trusted_check_lying_labels :
    ¬ claimResolvedBy trustedCheckSpace surfaceB currentClaim :=
  surfaceB_unresolved_of_admissible_lying (by decide) (by decide)

/-! ## 3. Surface B, honest labels and known current vintage -/

/-- B resolves the claim under honest labels and a known current vintage. -/
public theorem surfaceB_resolved_honest_known (k : Vintage) :
    claimResolvedBy (honestKnownSpace k) surfaceB currentClaim := by
  intro l r hl hr hobs
  obtain ⟨hlh, hlk⟩ := hl
  obtain ⟨hrh, hrk⟩ := hr
  have hobs' : l.label = r.label := hobs
  have hact : l.actual = r.actual := hlh.symm.trans (hobs'.trans hrh)
  change l.actual = l.truth ↔ r.actual = r.truth
  rw [hlk, hrk, hact]

/-- Honesty alone is not enough: the current vintage must also be known. -/
public theorem surfaceB_unresolved_honest_unknown_current :
    ¬ claimResolvedBy honestOnlySpace surfaceB currentClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wCurrent) (right := wStaleHonestMoved)
    (by decide) (by decide) rfl
    (by
      change ¬ (wCurrent.actual = wCurrent.truth ↔
        wStaleHonestMoved.actual = wStaleHonestMoved.truth)
      decide)

/-! ## 4. Surface C under explicit authority, currency, verification -/

/-- Under the three assumptions, the claim holds exactly when the check passes. -/
theorem current_iff_check {w : VWorld}
    (ha : IsAuthoritative w) (hc : IsCurrentAtCheck w)
    (hv : CheckCorrect w) :
    w.actual = w.truth ↔ w.check = true := by
  have hv' : w.check = true ↔ w.actual = w.reference := hv
  rw [hv', ha, hc]

/-- C resolves the claim under authority, currency and verification correctness. -/
public theorem surfaceC_resolved_trusted_check :
    claimResolvedBy trustedCheckSpace surfaceC currentClaim := by
  intro l r hl hr hobs
  obtain ⟨hla, hlc, hlv⟩ := hl
  obtain ⟨hra, hrc, hrv⟩ := hr
  have hobs' : l.check = r.check := hobs
  change l.actual = l.truth ↔ r.actual = r.truth
  rw [current_iff_check hla hlc hlv, current_iff_check hra hrc hrv, hobs']

/-- Without authority, C need not resolve the claim. -/
public theorem surfaceC_unresolved_without_authority :
    ¬ claimResolvedBy noAuthoritySpace surfaceC currentClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wCurrent) (right := wWrongReference)
    (by decide) (by decide) rfl
    (by
      change ¬ (wCurrent.actual = wCurrent.truth ↔
        wWrongReference.actual = wWrongReference.truth)
      decide)

/-- Without currency, C need not resolve the claim. -/
public theorem surfaceC_unresolved_without_currency :
    ¬ claimResolvedBy noCurrencySpace surfaceC currentClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wCurrent) (right := wSuperseded)
    (by decide) (by decide) rfl
    (by
      change ¬ (wCurrent.actual = wCurrent.truth ↔
        wSuperseded.actual = wSuperseded.truth)
      decide)

/-- Without verification correctness, C need not resolve the claim. -/
public theorem surfaceC_unresolved_without_verification :
    ¬ claimResolvedBy noVerificationSpace surfaceC currentClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wCurrent) (right := wFaultyCheck)
    (by decide) (by decide) rfl
    (by
      change ¬ (wCurrent.actual = wCurrent.truth ↔
        wFaultyCheck.actual = wFaultyCheck.truth)
      decide)

/-! ## 5. Witness-level transfer to a richer concrete toy model -/

/--
A concrete precinct dataset with three precincts, a dataset-level
vintage label, and a currently applicable vintage.

Individual precincts may have different geometry vintages.
-/
public structure PWorld where
  /-- Actual geometry vintage of each precinct. -/
  precinct : Fin 3 → Vintage

  /-- Self-reported vintage of the dataset as a whole. -/
  label : Vintage

  /-- Vintage currently applicable to the dataset. -/
  truth : Vintage

/-- Concrete claim: every precinct's geometry is current. -/
public def concreteClaim : Claim PWorld where
  holds := fun w => ∀ i, w.precinct i = w.truth

/-- Concrete surface B: only the dataset-level label is observed. -/
public def concreteSurfaceB : ObservationModel PWorld Vintage where
  observe := fun w => w.label

/-- The abstract resolution-failure witness for B with lying labels. -/
public def surfaceBWitness :
    ResolutionFailureWitness allWorlds surfaceB currentClaim where
  left := wCurrent
  right := wStaleLying
  leftAdmissible := trivial
  rightAdmissible := trivial
  sameObservation := rfl
  claimDisagrees := by
    change ¬ (wCurrent.actual = wCurrent.truth ↔
      wStaleLying.actual = wStaleLying.truth)
    decide

/--
Realization of the abstract witness in the concrete model. The stale side is
realized by a *mixed* dataset (only precinct 0 stale), which has no
counterpart among the abstract worlds. Only this one pair is realized; no
global map from abstract to concrete worlds is required.
-/
public def surfaceBWitnessRealization :
    WitnessRealization surfaceBWitness
      (WorldSpace.unrestricted PWorld) concreteSurfaceB concreteClaim where
  left := ⟨fun _ => .v2025, .v2025, .v2025⟩
  right := ⟨fun i => if i = 0 then .v2024 else .v2025, .v2025, .v2025⟩
  leftAdmissible := trivial
  rightAdmissible := trivial
  leftClaim := ⟨fun _ => rfl, fun _ _ => rfl⟩
  rightClaim :=
    ⟨fun h => absurd (h 0) (by decide),
     fun h => absurd h
       (by
         change ¬ (wStaleLying.actual = wStaleLying.truth)
         decide)⟩
  observationPreserved := fun _ => rfl

/-- The concrete label-only surface cannot resolve the concrete claim. -/
public theorem concreteSurfaceB_unresolved :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted PWorld) concreteSurfaceB concreteClaim :=
  surfaceBWitnessRealization.not_claimResolvedBy

/-! ## Sanity tests (compile-time) -/

example : currentClaim.holds wCurrent := rfl
example : ¬ currentClaim.holds wStale := by
  change ¬ (wStale.actual = wStale.truth)
  decide
example : ¬ currentClaim.holds wStaleLying := by
  change ¬ (wStaleLying.actual = wStaleLying.truth)
  decide
example : surfaceB.observe wStaleLying = surfaceB.observe wCurrent := rfl
example : surfaceC.observe wStale ≠ surfaceC.observe wCurrent := by decide
example : (fullyAssumedSpace .v2025).admissible wCurrent := by decide
example : (fullyAssumedSpace .v2025).admissible wStale := by decide
example : ¬ (honestKnownSpace .v2025).admissible wStaleLying := by decide
example : ¬ trustedCheckSpace.admissible wFaultyCheck := by decide
example : ¬ trustedCheckSpace.admissible wWrongReference := by decide
example : ¬ trustedCheckSpace.admissible wSuperseded := by decide

end SE.StructuralAssurability.PrecinctVintage
