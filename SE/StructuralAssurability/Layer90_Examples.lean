/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all
public import SE.StructuralAssurability.Layer90_Examples.Architectures
public import SE.StructuralAssurability.Layer90_Examples.Case1_UnauthorizedAction
public import SE.StructuralAssurability.Layer90_Examples.Case2_OutputProperty
public import SE.StructuralAssurability.Layer90_Examples.Case3_Incomparability
public import SE.StructuralAssurability.Layer90_Examples.PrecinctVintage
public import SE.StructuralAssurability.Layer90_Examples.DeploymentShift

/-!
# Layer 90: Examples

Representative applications of Structural Assurability and claim-relative
resolution.

The examples instantiate the abstract theory using simplified architectures,
finite world spaces, explicit evidence surfaces, and specified assurance
contexts. They introduce no new foundational semantics.

## Comparative Structural Assurability

The three original manuscript cases demonstrate:

- strict comparative dominance;
- assurability equivalence; and
- assurability incomparability.

These results concern claim-relative capability profiles, not rankings of
architecture classes or guarantees of claim resolution.

The unauthorized-action example additionally demonstrates the
indistinguishable-world resolution bound: an observation surface cannot
resolve a claim when two admissible worlds produce identical observations
but disagree on that claim.

## Precinct Vintage

`PrecinctVintage` examines the claim that a precinct dataset is current
under three evidence surfaces:

- A: a bare dataset snapshot;
- B: a dataset with a self-reported vintage label;
- C: a dataset with an independent reference check.

The example establishes that a bare snapshot cannot resolve the claim,
and a self-reported label cannot resolve it while inaccurate labels
remain admissible.

The label resolves the claim when label honesty and knowledge of the
current vintage are both assumed. The independent check resolves the
claim under explicit reference-authority, reference-currency, and
verification-correctness assumptions.

Removing any one of the three checker assumptions admits a
resolution-failure witness in the corresponding world space.

An abstract failure witness for the label-only surface is realized in
a richer three-precinct model containing a mixed-vintage dataset.

## Deployment Shift

`DeploymentShift` examines the claim that a deployed classifier meets
an accuracy threshold over a fixed finite deployment population.

Three evidence surfaces are compared:

- A: offline validation metrics;
- B: offline metrics plus input-drift monitoring;
- C: labeled production observations.

Offline metrics cannot resolve the deployment-accuracy claim over the
unrestricted world space. Adding a drift indicator does not establish
resolution: admissible worlds can report identical drift while having
different deployment accuracy.

A partial labeled sample also cannot necessarily resolve the claim.
Full labeling resolves it in the finite model. Partial labeling resolves
it under the explicit `StrataRepresentative` assumption, which determines
the correctness of the unlabeled case from a specified labeled case.

The weaker `WeakRepresentative` assumption does not suffice.

An abstract drift-monitoring failure witness is realized in a richer
six-case deployment model with numeric offline accuracy and drift scores.

The finite models establish exact-count claims, not statistical
estimates of deployment accuracy.

## Approximation and Witness Transfer

Both new examples exercise `WitnessRealization` from Layer 30.

Each constructs a concrete realization of an abstract
resolution-failure witness, preserving admissibility, claim disagreement,
and observational indistinguishability for the selected pair.

These constructions require no global mapping between abstract and
concrete world spaces.

They demonstrate mathematical witness transfer between specified
models. They do not establish that either concrete toy model faithfully
represents an operational system.

## Scope and Outstanding Assumptions

All results are relative to the stated claims, observation models,
admissible worlds, and, where applicable, evaluator conditions and
resource constraints.

Applying the resolution results to real systems requires independent
justification of the relevant assumptions, including:

- observation faithfulness: the modeled surface accurately represents
  what the evaluator can observe;
- witness realizability: the relevant claim-disagreeing worlds can
  occur in the system being assessed;
- precinct evidence: label honesty, knowledge of the current vintage,
  reference authority, reference currency, and verification correctness;
- deployment evidence: label correctness, sample coverage, selection
  mechanisms, and any claimed relationship between labeled and
  unlabeled cases; and
- claim scope: the population, time, threshold, and meaning of the
  claim being evaluated.

The counterexamples establish that particular admissible world pairs
defeat the stated resolution guarantees. They do not establish that
the omitted assumptions are necessary in every possible observation
model.

Neither example establishes empirical properties of an actual precinct
pipeline or deployed classifier. The deployment model additionally
excludes sampling error and statistical uncertainty.

No scalar assurability score or general implication from capability
dominance to claim resolution is introduced.
-/
