# Limitations

The current formalization is intentionally bounded.

It does **not** establish that the current candidate structural properties are
complete.

It does **not** establish universal necessity, mutual independence, or joint
sufficiency of those properties.

It does **not** assume that more evidence always produces more evidentiary
capability.

It does **not** assign systems a universal scalar assurability score.

It does **not** infer that a more assurable system is safer, more trustworthy, or
more likely to satisfy the evaluated claim.

It does **not** replace an assurance argument or determine its final conclusion.

## Capability Profiles and Claim Resolution

The capability-ordering and claim-resolution mechanisms are distinct.

Strict Structural Assurability dominance does not imply improved
claim-resolving power.
Additional claim-material capabilities may leave the
observation model's ability to resolve a claim unchanged.

The formalization does not derive a system-specific observation model
directly from evidence accessibility, resource feasibility,
materiality, or capability semantics.

## Approximation Transfer

The approximation-transfer theorems establish sufficient conditions
under which claim-resolution results can be transferred between
abstract and concrete observation models.

Applying these results to operational systems requires independent
justification of the relevant assumptions, including:

- admissibility and realizability of the modeled worlds;
- preservation of claim truth;
- faithfulness of the modeled observations; and
- the applicable relationship between abstract and concrete observations.

Witness-level transfer requires exhibiting only one concrete
resolution-failure witness rather than specifying a global mapping.

Under the current definitions, however, a global failure transfer
can also be constructed from one realized witness using a
claim-dependent mapping.
Neither construction independently establishes a
faithful relationship with an operational system.

## Finite-World Examples

The representative architecture examples establish that the formal
relations can express strict dominance, equivalence, and incomparability.
A separate observation-model construction demonstrates
claim-resolution failure.

The precinct-vintage and deployment-shift examples demonstrate
claim-relative resolution and failure
under **explicitly stated assumptions**.

These examples do **not** establish empirical properties of actual
precinct-data pipelines or deployed classifiers.

In particular, the deployment example uses a finite population
with exact correctness values.
It does **not** establish
statistical sampling guarantees,
confidence intervals, or
bounds on deployment-accuracy estimation error.

The counterexamples demonstrate that particular admissible
world pairs defeat the stated resolution guarantees.
They do **not** establish that the omitted assumptions are necessary
in every possible observation model.

Future extensions should preserve these distinctions unless
the formal theory is intentionally revised.

## Dimension-Specific Separating Constructions

The generic `SeparatingConstruction` interface remains unrestricted and
accepts caller-supplied difference relations.
The four dimension-specific constructions
provide profile-grounded, dimension-locked alternatives for
**observability**, **evidence coverage**, **traceability**,
and **reconstructability**.

Independence, integrity, and controllability
do not yet have corresponding dimension-specific constructions.

For **independence** and **integrity**, establishing the assurance
significance of a profile difference requires additional
assumptions concerning evidence provenance, admissibility,
and trust.

For **controllability**, connecting interventions to claim
resolution requires representing how the evaluator's
observations depend on permitted interventions and
applicable resource constraints.
The current claim-resolution model does not
represent those interactions.

## Source of Truth

- [Layer50_Properties.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer50_Properties.lean)
- [Layer60_Theorems.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer60_Theorems.lean)
- [Layer90_Examples.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer90_Examples.lean)
