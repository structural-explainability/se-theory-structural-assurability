# Deployment Shift

The deployment-shift example examines whether available
evidence can resolve a claim about classification accuracy
in a deployed system.

The finite model contains three deployment cases.
The claim holds when at least two of the three cases
are classified correctly.

Each world also records an offline-metrics flag
and an input-drift flag.

## Evidence Surfaces

- **A:** Offline validation metrics.
- **B:** Offline metrics and input-drift monitoring.
- **C:** Labeled production observations.

Surface C is parameterized by which
deployment cases have been labeled.

A labeled case reveals its correctness exactly.

## Resolution Results

Surface A cannot resolve the deployment-accuracy claim
over the unrestricted world space.

Surface B also cannot necessarily resolve it.

The model includes admissible worlds with identical
offline and drift observations but different
deployment-accuracy outcomes.

This occurs both when no drift is reported and
when drift is reported.

Consequently, the drift indicator does not
establish whether the deployment-accuracy claim holds.

## Labeled Production Evidence

A partial labeled sample covering cases 0 and 1
cannot resolve the claim
over the unrestricted world space.

Two worlds can agree on the correctness of both
labeled cases while differing on the unlabeled case,
causing the accuracy claim to have different truth values.

Full labeling resolves the claim without
additional world-space restrictions.

The partial sample also resolves the claim under
the explicit `StrataRepresentative` assumption,
which requires the unlabeled case to have the same
correctness value as labeled case 0.

A weaker assumption that the unlabeled case
resembles some labeled case does not suffice.

These are exact properties of the finite model,
not statistical representativeness guarantees.

## Witness-Level Transfer

The example realizes an abstract drift-monitoring
resolution-failure witness in a richer model
containing six deployment cases.

The concrete worlds have different deployment-accuracy
outcomes but identical modeled offline-accuracy
and drift-score observations.

The construction demonstrates witness-level transfer
without requiring a global mapping between
abstract and concrete world spaces.

## Application Boundaries

Applying these results to a deployed classifier
would require independent justification of:

- the correctness and availability of production labels;
- the selection mechanism for labeled observations;
- the coverage of the deployment population;
- any assumed relationship between labeled and
  unlabeled cases;
- the meaning and validity of offline and drift metrics;
- the completeness of the evaluator's observation surface;
- the realizability of the witness worlds; and
- the deployment window, target population, and
  accuracy threshold defining the claim.

The finite model uses exact correctness values
and contains no statistical sampling-error model.

It does not establish confidence intervals,
statistical representativeness, or empirical
accuracy for a real deployed classifier.

## Source of Truth

- [DeploymentShift.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer90_Examples/DeploymentShift.lean)
- [ApproximationTransfer.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/ApproximationTransfer.lean)
