/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer30_Core.Bounds

namespace SE.StructuralAssurability

universe uWA uWC uOA uOC

/-!
# Two-sided approximation of resolution results

An *abstract* setting (`WA`, `OA`) is related to a *concrete* setting
(`WC`, `OC`). Abstract results are transferred to the concrete setting only
under explicit hypotheses relating worlds, claims, admissibility, and
observations. Nothing here touches capability profiles.

* Failure transfer (impossibility): abstract worlds are realized as concrete
  worlds; concrete observations are determined by abstract observations.
* Resolution transfer (possibility): concrete worlds are covered by abstract
  worlds; abstract observations are determined by concrete observations.
-/

/-! ## 1. Failure transfer -/

/--
Hypotheses under which an abstract resolution failure implies a concrete one.

* `realize` maps abstract worlds to concrete worlds;
* admissible abstract worlds realize as admissible concrete worlds;
* claim truth is preserved on admissible abstract worlds;
* concrete observations factor through abstract observations on admissible
  abstract worlds (the abstract model shows the evaluator at least everything
  the concrete setting does).
-/
public structure FailureTransfer
    {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
    (spaceA : WorldSpace WA) (modelA : ObservationModel WA OA)
    (claimA : Claim WA)
    (spaceC : WorldSpace WC) (modelC : ObservationModel WC OC)
    (claimC : Claim WC) where
  /-- Concrete realization of an abstract world. -/
  realize : WA → WC
  /-- Admissible abstract worlds have admissible concrete realizations. -/
  admissible : ∀ {w}, spaceA.admissible w → spaceC.admissible (realize w)
  /-- The claim has the same truth value in a world and its realization. -/
  claimPreserved :
    ∀ {w}, spaceA.admissible w → (claimC (realize w) ↔ claimA w)
  /-- Concrete observation is a function of abstract observation. -/
  observationFactors :
    ∃ g : OA → OC, ∀ {w}, spaceA.admissible w →
      modelC.observe (realize w) = g (modelA.observe w)

namespace FailureTransfer

variable
  {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
  {spaceA : WorldSpace WA} {modelA : ObservationModel WA OA}
  {claimA : Claim WA}
  {spaceC : WorldSpace WC} {modelC : ObservationModel WC OC}
  {claimC : Claim WC}

/--
Factorization implies that realization preserves indistinguishability of
admissible worlds. This is the only consequence of `observationFactors` used
below.
-/
public theorem indistinguishable_realize
    (T : FailureTransfer spaceA modelA claimA spaceC modelC claimC)
    {a b : WA}
    (ha : spaceA.admissible a) (hb : spaceA.admissible b)
    (h : indistinguishable modelA a b) :
    indistinguishable modelC (T.realize a) (T.realize b) := by
  obtain ⟨g, hg⟩ := T.observationFactors
  change modelC.observe (T.realize a) = modelC.observe (T.realize b)
  rw [hg ha, hg hb]
  exact congrArg g h

/-- Requirement 1: an abstract failure witness transfers to a concrete one. -/
public def transferWitness
    (T : FailureTransfer spaceA modelA claimA spaceC modelC claimC)
    (w : ResolutionFailureWitness spaceA modelA claimA) :
    ResolutionFailureWitness spaceC modelC claimC where
  left := T.realize w.left
  right := T.realize w.right
  leftAdmissible := T.admissible w.leftAdmissible
  rightAdmissible := T.admissible w.rightAdmissible
  sameObservation :=
    T.indistinguishable_realize
      w.leftAdmissible w.rightAdmissible w.sameObservation
  claimDisagrees := fun h =>
    w.claimDisagrees
      (((T.claimPreserved w.leftAdmissible).symm.trans h).trans
        (T.claimPreserved w.rightAdmissible))

/-- An abstract failure witness yields concrete unresolvability. -/
public theorem not_claimResolvedBy_of_abstract_witness
    (T : FailureTransfer spaceA modelA claimA spaceC modelC claimC)
    (w : ResolutionFailureWitness spaceA modelA claimA) :
    ¬ claimResolvedBy spaceC modelC claimC :=
  not_claimResolvedBy_of_witness (T.transferWitness w)

/--
Contrapositive form, requiring no explicit witness: if the concrete setting
resolves the claim, so does the abstract one.
-/
public theorem claimResolvedBy_abstract
    (T : FailureTransfer spaceA modelA claimA spaceC modelC claimC) :
    claimResolvedBy spaceC modelC claimC →
    claimResolvedBy spaceA modelA claimA := by
  intro hC a b ha hb hab
  have h :=
    hC (T.admissible ha) (T.admissible hb)
      (T.indistinguishable_realize ha hb hab)
  exact ((T.claimPreserved ha).symm.trans h).trans (T.claimPreserved hb)

/-- Abstract unresolvability implies concrete unresolvability. -/
public theorem not_claimResolvedBy_transfer
    (T : FailureTransfer spaceA modelA claimA spaceC modelC claimC) :
    ¬ claimResolvedBy spaceA modelA claimA →
    ¬ claimResolvedBy spaceC modelC claimC :=
  fun hA hC => hA (T.claimResolvedBy_abstract hC)

end FailureTransfer

/-! ## 2. Resolution transfer -/

/--
Hypotheses under which abstract resolution implies concrete resolution: the
reverse abstraction conditions.

* `cover` maps concrete worlds to abstract worlds;
* admissible concrete worlds are covered by admissible abstract worlds;
* claim truth is preserved on admissible concrete worlds;
* abstract observations factor through concrete observations on admissible
  concrete worlds (the abstract model shows the evaluator no more than the
  concrete setting does).
-/
public structure ResolutionTransfer
    {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
    (spaceA : WorldSpace WA) (modelA : ObservationModel WA OA)
    (claimA : Claim WA)
    (spaceC : WorldSpace WC) (modelC : ObservationModel WC OC)
    (claimC : Claim WC) where
  /-- Abstract world covering a concrete world. -/
  cover : WC → WA
  /-- Admissible concrete worlds are covered by admissible abstract worlds. -/
  admissible : ∀ {v}, spaceC.admissible v → spaceA.admissible (cover v)
  /-- The claim has the same truth value in a world and its cover. -/
  claimPreserved :
    ∀ {v}, spaceC.admissible v → (claimA (cover v) ↔ claimC v)
  /-- Abstract observation is a function of concrete observation. -/
  observationFactors :
    ∃ g : OC → OA, ∀ {v}, spaceC.admissible v →
      modelA.observe (cover v) = g (modelC.observe v)

namespace ResolutionTransfer

variable
  {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
  {spaceA : WorldSpace WA} {modelA : ObservationModel WA OA}
  {claimA : Claim WA}
  {spaceC : WorldSpace WC} {modelC : ObservationModel WC OC}
  {claimC : Claim WC}

/-- Covering preserves indistinguishability of admissible concrete worlds. -/
public theorem indistinguishable_cover
    (T : ResolutionTransfer spaceA modelA claimA spaceC modelC claimC)
    {a b : WC}
    (ha : spaceC.admissible a) (hb : spaceC.admissible b)
    (h : indistinguishable modelC a b) :
    indistinguishable modelA (T.cover a) (T.cover b) := by
  obtain ⟨g, hg⟩ := T.observationFactors
  change modelA.observe (T.cover a) = modelA.observe (T.cover b)
  rw [hg ha, hg hb]
  exact congrArg g h

/-- Requirement 2: abstract resolution implies concrete resolution. -/
public theorem claimResolvedBy_transfer
    (T : ResolutionTransfer spaceA modelA claimA spaceC modelC claimC) :
    claimResolvedBy spaceA modelA claimA →
    claimResolvedBy spaceC modelC claimC := by
  intro hA a b ha hb hab
  have h :=
    hA (T.admissible ha) (T.admissible hb)
      (T.indistinguishable_cover ha hb hab)
  exact ((T.claimPreserved ha).symm.trans h).trans (T.claimPreserved hb)

/-- Concrete unresolvability implies abstract unresolvability. -/
public theorem not_claimResolvedBy_abstract
    (T : ResolutionTransfer spaceA modelA claimA spaceC modelC claimC) :
    ¬ claimResolvedBy spaceC modelC claimC →
    ¬ claimResolvedBy spaceA modelA claimA :=
  fun hC hA => hC (T.claimResolvedBy_transfer hA)

end ResolutionTransfer

/-! ## 3. Weaker impossibility: realize one witness only -/

/--
A concrete realization of one abstract resolution-failure witness. No global
map, no global admissibility or factorization: only the two witness worlds are
realized, with the claim and the indistinguishability relation respected on
that pair.
-/
public structure WitnessRealization
    {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
    {spaceA : WorldSpace WA} {modelA : ObservationModel WA OA}
    {claimA : Claim WA}
    (w : ResolutionFailureWitness spaceA modelA claimA)
    (spaceC : WorldSpace WC) (modelC : ObservationModel WC OC)
    (claimC : Claim WC) where
  /-- Concrete world realizing the abstract left world. -/
  left : WC
  /-- Concrete world realizing the abstract right world. -/
  right : WC
  leftAdmissible : spaceC.admissible left
  rightAdmissible : spaceC.admissible right
  leftClaim : claimC left ↔ claimA w.left
  rightClaim : claimC right ↔ claimA w.right
  /-- Pair-local observation preservation. -/
  observationPreserved :
    indistinguishable modelA w.left w.right →
    indistinguishable modelC left right

namespace WitnessRealization

variable
  {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
  {spaceA : WorldSpace WA} {modelA : ObservationModel WA OA}
  {claimA : Claim WA}
  {w : ResolutionFailureWitness spaceA modelA claimA}
  {spaceC : WorldSpace WC} {modelC : ObservationModel WC OC}
  {claimC : Claim WC}

/-- Requirement 3: realizing one abstract witness suffices for impossibility. -/
public def toWitness
    (R : WitnessRealization w spaceC modelC claimC) :
    ResolutionFailureWitness spaceC modelC claimC where
  left := R.left
  right := R.right
  leftAdmissible := R.leftAdmissible
  rightAdmissible := R.rightAdmissible
  sameObservation := R.observationPreserved w.sameObservation
  claimDisagrees := fun h =>
    w.claimDisagrees ((R.leftClaim.symm.trans h).trans R.rightClaim)

public theorem not_claimResolvedBy
    (R : WitnessRealization w spaceC modelC claimC) :
    ¬ claimResolvedBy spaceC modelC claimC :=
  not_claimResolvedBy_of_witness R.toWitness

end WitnessRealization

/-- A global failure transfer realizes every abstract witness, so the
witness-level hypothesis is strictly weaker than `FailureTransfer`. -/
public def FailureTransfer.toWitnessRealization
    {WA : Type uWA} {WC : Type uWC} {OA : Type uOA} {OC : Type uOC}
    {spaceA : WorldSpace WA} {modelA : ObservationModel WA OA}
    {claimA : Claim WA}
    {spaceC : WorldSpace WC} {modelC : ObservationModel WC OC}
    {claimC : Claim WC}
    (T : FailureTransfer spaceA modelA claimA spaceC modelC claimC)
    (w : ResolutionFailureWitness spaceA modelA claimA) :
    WitnessRealization w spaceC modelC claimC where
  left := T.realize w.left
  right := T.realize w.right
  leftAdmissible := T.admissible w.leftAdmissible
  rightAdmissible := T.admissible w.rightAdmissible
  leftClaim := T.claimPreserved w.leftAdmissible
  rightClaim := T.claimPreserved w.rightAdmissible
  observationPreserved :=
    T.indistinguishable_realize w.leftAdmissible w.rightAdmissible

/-! ## 4. Counterexamples: the observation relationship matters -/

/-- Claim on `Bool`: holds exactly at `true`. -/
public def cexClaim : Claim Bool where
  holds := fun b => b = true

/-- Abstract observation: reveals nothing. -/
public def cexCoarse : ObservationModel Bool Unit where
  observe := fun _ => ()

/-- Concrete observation: reveals everything. -/
public def cexFine : ObservationModel Bool Bool where
  observe := fun b => b

/--
Failure transfer with the identity map: admissibility and claim preservation
hold, but the concrete observation is strictly finer, so it does not factor
through the abstract one.
-/
public theorem cex_failure_observation_hypothesis_needed :
    -- all non-observation hypotheses hold for `realize := id`
    (∀ {w : Bool},
      (WorldSpace.unrestricted Bool).admissible w →
      (WorldSpace.unrestricted Bool).admissible (id w)) ∧
    (∀ {w : Bool},
      (WorldSpace.unrestricted Bool).admissible w →
      (cexClaim (id w) ↔ cexClaim w)) ∧
    -- abstract failure holds
    ¬ claimResolvedBy (WorldSpace.unrestricted Bool) cexCoarse cexClaim ∧
    -- observation factorization fails
    ¬ (∃ g : Unit → Bool, ∀ {w : Bool},
        (WorldSpace.unrestricted Bool).admissible w →
        cexFine.observe (id w) = g (cexCoarse.observe w)) ∧
    -- and the transfer conclusion fails
    claimResolvedBy (WorldSpace.unrestricted Bool) cexFine cexClaim := by
  refine ⟨fun _ => trivial, fun _ => Iff.rfl, ?_, ?_, ?_⟩
  · exact not_claimResolvedBy_of_indistinguishable_disagreement
      (left := true) (right := false) trivial trivial rfl
      (by
        change ¬ (cexClaim true ↔ cexClaim false)
        simp [cexClaim])
  · rintro ⟨g, hg⟩
    have h1 : true = g () := hg (w := true) trivial
    have h2 : false = g () := hg (w := false) trivial
    rw [← h2] at h1
    exact Bool.noConfusion h1
  · intro a b _ _ hab
    change a = b at hab
    subst hab
    exact Iff.rfl

/--
Dual counterexample for resolution transfer: abstract observation strictly
finer than concrete, so abstract resolution does not transfer.
-/
public theorem cex_resolution_observation_hypothesis_needed :
    claimResolvedBy (WorldSpace.unrestricted Bool) cexFine cexClaim ∧
    ¬ claimResolvedBy (WorldSpace.unrestricted Bool) cexCoarse cexClaim ∧
    ¬ (∃ g : Unit → Bool, ∀ {v : Bool},
        (WorldSpace.unrestricted Bool).admissible v →
        cexFine.observe (id v) = g (cexCoarse.observe v)) := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b _ _ hab
    change a = b at hab
    subst hab
    exact Iff.rfl
  · exact not_claimResolvedBy_of_indistinguishable_disagreement
      (left := true) (right := false) trivial trivial rfl
      (by
        change ¬ (cexClaim true ↔ cexClaim false)
        simp [cexClaim])
  · rintro ⟨g, hg⟩
    have h1 : true = g () := hg (v := true) trivial
    have h2 : false = g () := hg (v := false) trivial
    rw [← h2] at h1
    exact Bool.noConfusion h1

/-! ## Instantiation tests (theorems applied to concrete data) -/

/-- Concrete worlds carry irrelevant extra detail (`Fin 3`). -/
private def testClaimC : Claim (Bool × Fin 3) where
  holds := fun p => p.1 = true

private def testObsC : ObservationModel (Bool × Fin 3) Unit where
  observe := fun _ => ()

/-- Failure transfer from the coarse two-world model to a richer setting. -/
private def testFailureTransfer :
    FailureTransfer
      (WorldSpace.unrestricted Bool) cexCoarse cexClaim
      (WorldSpace.unrestricted (Bool × Fin 3)) testObsC testClaimC where
  realize := fun b => (b, 0)
  admissible := fun _ => trivial
  claimPreserved := fun _ => Iff.rfl
  observationFactors := ⟨fun u => u, fun _ => rfl⟩

private theorem test_concrete_unresolved :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted (Bool × Fin 3)) testObsC testClaimC :=
  testFailureTransfer.not_claimResolvedBy_transfer
    (not_claimResolvedBy_of_indistinguishable_disagreement
      (left := true) (right := false) trivial trivial rfl
      (by
        change ¬ (cexClaim true ↔ cexClaim false)
        simp [cexClaim]))

/-- Resolution transfer: the concrete setting reveals the `Bool` component. -/
private def testConcreteObs : ObservationModel (Bool × Fin 3) Bool where
  observe := fun p => p.1

private def testResolutionTransfer :
    ResolutionTransfer
      (WorldSpace.unrestricted Bool) cexFine cexClaim
      (WorldSpace.unrestricted (Bool × Fin 3)) testConcreteObs testClaimC where
  cover := fun p => p.1
  admissible := fun _ => trivial
  claimPreserved := fun _ => Iff.rfl
  observationFactors := ⟨fun b => b, fun _ => rfl⟩

private theorem test_concrete_resolved :
    claimResolvedBy
      (WorldSpace.unrestricted (Bool × Fin 3)) testConcreteObs testClaimC :=
  testResolutionTransfer.claimResolvedBy_transfer
    (by
      intro a b _ _ hab
      change a = b at hab
      subst hab
      exact Iff.rfl)

/-- Witness-level realization with a strictly smaller hypothesis set. -/
private def testWitnessRealization :
    WitnessRealization
      (spaceA := WorldSpace.unrestricted Bool) (modelA := cexCoarse)
      (claimA := cexClaim)
      ({ left := true, right := false
         leftAdmissible := trivial, rightAdmissible := trivial
         sameObservation := rfl
         claimDisagrees := by
           change ¬ (cexClaim true ↔ cexClaim false)
           simp [cexClaim] } :
        ResolutionFailureWitness
          (WorldSpace.unrestricted Bool) cexCoarse cexClaim)
      (WorldSpace.unrestricted (Bool × Fin 3)) testObsC testClaimC where
  left := (true, 0)
  right := (false, 2)
  leftAdmissible := trivial
  rightAdmissible := trivial
  leftClaim := Iff.rfl
  rightClaim := Iff.rfl
  observationPreserved := fun _ => rfl

private theorem test_witness_realization_unresolved :
    ¬ claimResolvedBy
      (WorldSpace.unrestricted (Bool × Fin 3)) testObsC testClaimC :=
  testWitnessRealization.not_claimResolvedBy

end SE.StructuralAssurability
