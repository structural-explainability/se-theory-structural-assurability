# Precinct Vintage

The precinct-vintage example examines the claim that
a dataset contains the currently applicable precinct data.

It uses a finite model with two possible vintages and
three evidence surfaces.

## Evidence Surfaces

- **A:** A bare dataset snapshot with no observable
  vintage information.
- **B:** A dataset exposing a self-reported vintage label.
- **C:** A dataset exposing the result of an independent
  check against a reference.

The claim is that the dataset's actual vintage equals
the vintage currently in effect.

## Resolution Results

Surface A cannot resolve the claim over the unrestricted
world space.
It remains unable to resolve the claim
even when every modeled assumption is imposed.

Surface B cannot resolve the claim while
inaccurate vintage labels remain admissible.

Knowing the current vintage does not overcome an
unreliable label.

Surface B resolves the claim when the label is honest
and the current vintage is known.

Label honesty alone is insufficient when the currently
applicable vintage remains unknown to the evaluator.

Surface C resolves the claim under
three explicit assumptions:

- **Reference authority:** the reference reports the
  vintage that was current when it was consulted.
- **Reference currency:** that vintage remains current
  when the claim is evaluated.
- **Verification correctness:** the check reports success
  exactly when the dataset's actual vintage matches
  the reference.

Removing any one of these assumptions admits a
resolution-failure witness in the corresponding
enlarged world space.

## Witness-Level Transfer

The example constructs an abstract resolution-failure
witness for the self-reported-label surface.

That witness is realized in a richer three-precinct
model containing a mixed-vintage dataset.

The concrete model's claim requires every precinct's
geometry to be current.

The stale concrete world contains one outdated precinct
while retaining a dataset-level label reporting the
current vintage.

Both concrete worlds produce the same label observation,
but they disagree on the claim.

The construction uses `WitnessRealization` and does
not require a global mapping between the two world spaces.

## Application Boundaries

Applying these results to an operational precinct-data
pipeline would require independent justification of:

- the realizability of the witness worlds;
- the completeness of the modeled observation surface;
- the reliability of the dataset's vintage label;
- the definition and availability of the current vintage;
- reference authority and currency;
- verification correctness; and
- the intended scope of the currency claim.

The finite model does not establish that any particular
published precinct dataset is current or outdated.

Its results are conditional on the modeled worlds,
observations, and explicit assumptions.

## Source of Truth

- [PrecinctVintage.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer90_Examples/PrecinctVintage.lean)
- [ApproximationTransfer.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/ApproximationTransfer.lean)
