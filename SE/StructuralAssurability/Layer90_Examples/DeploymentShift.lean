/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer30_Core.Bounds
public import SE.StructuralAssurability.Layer30_Core.ApproximationTransfer

namespace SE.StructuralAssurability.DeploymentShift

/-!
# Deployment-shift example: claim-relative resolution of accuracy

A finite toy model of the claim "the deployed classifier meets its accuracy
bar over the deployment population" under three evidence surfaces:

- **A** offline validation metrics;
- **B** offline validation metrics plus input-drift monitoring;
- **C** labeled production observations (a labeled sample of deployment cases).

This file is an *example*. It establishes facts about a finite model whose
worlds, claim, and observation functions are defined here. It establishes
nothing about any actual deployed system. It is independent of the
precinct-vintage example and imports only `Bounds` and `ApproximationTransfer`.

No capability profile, capability, or soundness predicate is used or added.

## Modeling choices

- The deployment population is a fixed finite set of cases. The claim is
  about the exact number of those cases the classifier gets right, not about a
  statistical accuracy over a distribution. Sampling error is not modeled.
- Each labeled case reveals exactly whether the classifier is correct on it.
  Label correctness and the choice of which cases are labeled are properties
  of the surface, not of the world.
- Offline metrics and the drift flag are world fields that are *not*
  constrained by deployment correctness unless a world-space restriction says
  so.

## Assumption register (each is a `WorldSpace` restriction or a surface choice)

- Coverage: every deployment case is labeled (a property of the surface).
- `StrataRepresentative`: the unlabeled case behaves, as to correctness, like
  a specific labeled case.
- `WeakRepresentative`: the unlabeled case behaves like at least one labeled
  case. This is shown *not* to suffice.

The failure results show that particular pairs of admissible worlds defeat the
stated resolution guarantee. They do not establish that the assumptions are
necessary for resolution in every possible observation model.
-/

/-! ## Model -/

/-- An abstract deployment world with three deployment cases. -/
public structure AWorld where
  /-- Whether offline validation metrics meet the offline bar. -/
  offlineOK : Bool
  /-- Whether input-drift monitoring reports drift. -/
  drift : Bool
  /-- Whether the classifier is correct on deployment case 0. -/
  c0 : Bool
  /-- Whether the classifier is correct on deployment case 1. -/
  c1 : Bool
  /-- Whether the classifier is correct on deployment case 2. -/
  c2 : Bool

/-- Number of deployment cases the classifier gets right. -/
public def numCorrect (w : AWorld) : Nat :=
  w.c0.toNat + w.c1.toNat + w.c2.toNat

/-- The claim: at least two of the three deployment cases are classified correctly. -/
public def deployClaim : Claim AWorld where
  holds := fun w => 2 ≤ numCorrect w

/-! ## Evidence surfaces -/

/-- A: offline validation metrics only. -/
public def surfaceA : ObservationModel AWorld Bool where
  observe := fun w => w.offlineOK

/-- B: offline validation metrics plus the input-drift flag. -/
public def surfaceB : ObservationModel AWorld (Bool × Bool) where
  observe := fun w => (w.offlineOK, w.drift)

/--
C: labeled production observations. The three flags say which deployment cases
are labeled; a labeled case reveals its correctness exactly.
-/
public def surfaceC (s0 s1 s2 : Bool) :
    ObservationModel AWorld (Option Bool × Option Bool × Option Bool) where
  observe := fun w =>
    (cond s0 (some w.c0) none,
     cond s1 (some w.c1) none,
     cond s2 (some w.c2) none)

/-! ## Assumptions -/

/-- No restriction: every world is admissible. -/
public abbrev allWorlds : WorldSpace AWorld :=
  WorldSpace.unrestricted AWorld

/-- Unlabeled case 2 behaves, as to correctness, like labeled case 0. -/
public abbrev StrataRepresentative (w : AWorld) : Prop := w.c2 = w.c0

/-- Unlabeled case 2 behaves like labeled case 0 or labeled case 1. -/
public abbrev WeakRepresentative (w : AWorld) : Prop :=
  w.c2 = w.c0 ∨ w.c2 = w.c1

/-- Worlds in which the unlabeled case is representative of case 0. -/
public abbrev strataRepresentativeSpace : WorldSpace AWorld where
  admissible := fun w => StrataRepresentative w

/-- Worlds in which the unlabeled case resembles some labeled case. -/
public abbrev weakRepresentativeSpace : WorldSpace AWorld where
  admissible := fun w => WeakRepresentative w

/-! ## Witness worlds -/

/-- Offline metrics fine, no drift, classifier correct everywhere. -/
public def wGood : AWorld where
  offlineOK := true
  drift := false
  c0 := true
  c1 := true
  c2 := true

/-- Same offline metrics and drift flag as `wGood`, classifier wrong everywhere. -/
public def wBad : AWorld where
  offlineOK := true
  drift := false
  c0 := false
  c1 := false
  c2 := false

/-- Drift reported, but the classifier remains correct everywhere. -/
public def wShiftBenign : AWorld where
  offlineOK := true
  drift := true
  c0 := true
  c1 := true
  c2 := true

/-- Drift reported, and the classifier fails everywhere. -/
public def wShiftHarmful : AWorld where
  offlineOK := true
  drift := true
  c0 := false
  c1 := false
  c2 := false

/-- Labeled cases 0 and 1 are (correct, wrong); unlabeled case 2 is correct. -/
public def wSampleMixedPass : AWorld where
  offlineOK := true
  drift := false
  c0 := true
  c1 := false
  c2 := true

/-- Labeled cases 0 and 1 are (correct, wrong); unlabeled case 2 is wrong. -/
public def wSampleMixedFail : AWorld where
  offlineOK := true
  drift := false
  c0 := true
  c1 := false
  c2 := false

/-! ## 1. Surface A cannot resolve the claim -/

/-- Offline metrics cannot resolve deployment accuracy over unrestricted worlds. -/
public theorem surfaceA_unresolved :
    ¬ claimResolvedBy allWorlds surfaceA deployClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wGood) (right := wBad) trivial trivial rfl
    (by
      change ¬ (2 ≤ numCorrect wGood ↔ 2 ≤ numCorrect wBad)
      decide)

/-! ## 2. Surface B, identical observed drift -/

/--
If two admissible worlds agree on offline metrics and the drift flag but
differ on the claim, B cannot resolve the claim over that world space.
-/
public theorem surfaceB_unresolved_of_same_drift
    {S : WorldSpace AWorld} {l r : AWorld}
    (hl : S.admissible l) (hr : S.admissible r)
    (hoff : l.offlineOK = r.offlineOK) (hdrift : l.drift = r.drift)
    (hdiff : ¬ (2 ≤ numCorrect l ↔ 2 ≤ numCorrect r)) :
    ¬ claimResolvedBy S surfaceB deployClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement hl hr
    (by
      change (l.offlineOK, l.drift) = (r.offlineOK, r.drift)
      rw [hoff, hdrift])
    hdiff

/-- No drift is reported in either world, yet deployment accuracy differs. -/
public theorem surfaceB_unresolved_no_drift_signal :
    ¬ claimResolvedBy allWorlds surfaceB deployClaim :=
  surfaceB_unresolved_of_same_drift (l := wGood) (r := wBad)
    trivial trivial rfl rfl (by decide)

/-- Drift is reported in both worlds, yet deployment accuracy differs. -/
public theorem surfaceB_unresolved_drift_signal :
    ¬ claimResolvedBy allWorlds surfaceB deployClaim :=
  surfaceB_unresolved_of_same_drift (l := wShiftBenign) (r := wShiftHarmful)
    trivial trivial rfl rfl (by decide)

/-! ## 3. A labeled sample need not resolve the entire deployment -/

/-- Labeling cases 0 and 1 only cannot resolve the claim over unrestricted worlds. -/
public theorem surfaceC_partial_unresolved :
    ¬ claimResolvedBy allWorlds (surfaceC true true false) deployClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wSampleMixedPass) (right := wSampleMixedFail) trivial trivial rfl
    (by
      change ¬ (2 ≤ numCorrect wSampleMixedPass ↔
        2 ≤ numCorrect wSampleMixedFail)
      decide)

/-! ## 4. Coverage and representativeness assumptions under which C resolves -/

/-- Labeling every deployment case resolves the claim with no world restriction. -/
public theorem surfaceC_full_coverage_resolved :
    claimResolvedBy allWorlds (surfaceC true true true) deployClaim := by
  intro l r _ _ h
  change (some l.c0, some l.c1, some l.c2) =
    (some r.c0, some r.c1, some r.c2) at h
  simp only [Prod.mk.injEq, Option.some.injEq] at h
  obtain ⟨h0, h1, h2⟩ := h
  change 2 ≤ numCorrect l ↔ 2 ≤ numCorrect r
  unfold numCorrect
  rw [h0, h1, h2]

/--
Labeling cases 0 and 1 resolves the claim when the unlabeled case is
representative of case 0.
-/
public theorem surfaceC_partial_resolved_representative :
    claimResolvedBy strataRepresentativeSpace
      (surfaceC true true false) deployClaim := by
  intro l r hl hr h
  change (some l.c0, some l.c1, (none : Option Bool)) =
    (some r.c0, some r.c1, (none : Option Bool)) at h
  simp only [Prod.mk.injEq, Option.some.injEq, and_true] at h
  obtain ⟨h0, h1⟩ := h
  have h2 : l.c2 = r.c2 := by
    have hl' : l.c2 = l.c0 := hl
    have hr' : r.c2 = r.c0 := hr
    rw [hl', hr', h0]
  change 2 ≤ numCorrect l ↔ 2 ≤ numCorrect r
  unfold numCorrect
  rw [h0, h1, h2]

/--
A weaker representativeness assumption does not defeat the failure witness:
the unlabeled case may resemble some labeled case and the claim is still
unresolved.
-/
public theorem surfaceC_partial_unresolved_weak_representative :
    ¬ claimResolvedBy weakRepresentativeSpace
      (surfaceC true true false) deployClaim :=
  not_claimResolvedBy_of_indistinguishable_disagreement
    (left := wSampleMixedPass) (right := wSampleMixedFail)
    (by decide) (by decide) rfl
    (by
      change ¬ (2 ≤ numCorrect wSampleMixedPass ↔
        2 ≤ numCorrect wSampleMixedFail)
      decide)

/-! ## 5. Witness-level transfer to a richer concrete deployment model -/

/--
A richer concrete deployment world: six deployment cases, a numeric offline
accuracy, and a numeric drift score.
-/
public structure CWorld where
  /-- Offline validation accuracy, in percent. -/
  offlineAcc : Nat
  /-- Input-drift monitoring score. -/
  driftScore : Nat
  /-- Whether the classifier is correct on each of the six deployment cases. -/
  correct : Fin 6 → Bool

/-- Number of the six concrete deployment cases classified correctly. -/
public def numCorrectC (w : CWorld) : Nat :=
  (w.correct 0).toNat + (w.correct 1).toNat + (w.correct 2).toNat +
  (w.correct 3).toNat + (w.correct 4).toNat + (w.correct 5).toNat

/-- Concrete claim: at least four of the six deployment cases are correct. -/
public def concreteClaim : Claim CWorld where
  holds := fun w => 4 ≤ numCorrectC w

/-- Concrete surface B: numeric offline accuracy and drift score. -/
public def concreteSurfaceB : ObservationModel CWorld (Nat × Nat) where
  observe := fun w => (w.offlineAcc, w.driftScore)

/-- The abstract resolution-failure witness for surface B. -/
public def surfaceBWitness :
    ResolutionFailureWitness allWorlds surfaceB deployClaim where
  left := wGood
  right := wBad
  leftAdmissible := trivial
  rightAdmissible := trivial
  sameObservation := rfl
  claimDisagrees := by
    change ¬ (2 ≤ numCorrect wGood ↔ 2 ≤ numCorrect wBad)
    decide

/-- Concrete world realizing the good side: every case correct. -/
public def cLeft : CWorld where
  offlineAcc := 92
  driftScore := 3
  correct := fun _ => true

/--
Concrete world realizing the bad side: same offline accuracy and drift score,
but only two of six cases correct.
-/
public def cRight : CWorld where
  offlineAcc := 92
  driftScore := 3
  correct := fun i => decide (i.val < 2)

/--
Realization of the abstract witness. Only this one pair is realized; no
global map from abstract to concrete worlds is required. The concrete pair
differs from the abstract one in scale, in numeric observations, and in the
pattern of failures.
-/
public def surfaceBWitnessRealization :
    WitnessRealization surfaceBWitness
      (WorldSpace.unrestricted CWorld) concreteSurfaceB concreteClaim where
  left := cLeft
  right := cRight
  leftAdmissible := trivial
  rightAdmissible := trivial
  leftClaim := by
    change 4 ≤ numCorrectC cLeft ↔ 2 ≤ numCorrect wGood
    decide
  rightClaim := by
    change 4 ≤ numCorrectC cRight ↔ 2 ≤ numCorrect wBad
    decide
  observationPreserved := fun _ => rfl

/-- The concrete offline-plus-drift surface cannot resolve the concrete claim. -/
public theorem concreteSurfaceB_unresolved :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted CWorld) concreteSurfaceB concreteClaim :=
  surfaceBWitnessRealization.not_claimResolvedBy

/-! ## Sanity tests (compile-time) -/

example : numCorrect wGood = 3 := by decide
example : numCorrect wBad = 0 := by decide
example : numCorrect wSampleMixedPass = 2 := by decide
example : numCorrect wSampleMixedFail = 1 := by decide
example : numCorrectC cLeft = 6 := by decide
example : numCorrectC cRight = 2 := by decide
example : surfaceA.observe wGood = surfaceA.observe wBad := rfl
example : surfaceB.observe wShiftBenign = surfaceB.observe wShiftHarmful := rfl
example : surfaceB.observe wGood ≠ surfaceB.observe wShiftBenign := by decide
example :
    (surfaceC true true false).observe wSampleMixedPass =
    (surfaceC true true false).observe wSampleMixedFail := rfl
example :
    (surfaceC true true true).observe wSampleMixedPass ≠
    (surfaceC true true true).observe wSampleMixedFail := by decide
/- The representative space is not vacuous: both claim values occur in it. -/
example : strataRepresentativeSpace.admissible wGood := by decide
example : strataRepresentativeSpace.admissible wBad := by decide
example : ¬ strataRepresentativeSpace.admissible wSampleMixedFail := by decide
example : weakRepresentativeSpace.admissible wSampleMixedPass := by decide
example : weakRepresentativeSpace.admissible wSampleMixedFail := by decide

end SE.StructuralAssurability.DeploymentShift
