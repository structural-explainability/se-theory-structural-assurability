# Formal Theory: Structural Assurability

Structural Assurability is a claim-relative theory of whether a system and
its evidence-producing environment make assurance-relevant evidence
practically obtainable by a specified evaluator under stated conditions.

The central question does not determine if the system is
generally auditable, transparent, or trustworthy.

The central question is:

> For this claim, under these evaluator conditions and resource constraints,
> what assurance-relevant distinctions can the available structure support?

## Core Model

For a system `S`, claim `C`, evaluator conditions `K`, and resource bounds `B`,
the theory considers:

```text
A(S, C, K, B)
```

as a claim-relative Structural Assurability profile.

The profile represents the evidentiary capabilities available for evaluating the
specified claim under the specified conditions.
It does not provide a scalar score.

The theory distinguishes:

```text
system structure
      ↓
obtainable evidence
      ↓
claim-material evidence
      ↓
evidentiary capabilities
      ↓
assurance reasoning
```

Structural Assurability formalizes the middle structural relationship.
It does not determine the final assurance conclusion.

## Formal Results

The Lean formalization supports:

- claim-relative evidence and capability models
- evaluator access and resource constraints
- observational indistinguishability
- claim-resolution bounds
- two-sided approximation transfer between
  abstract and concrete observation models
- witness-level transfer of resolution failures
- equivalence
- comparative dominance
- strict dominance
- incomparability
- separating constructions
- access and resource expansion
- conservative extension
- representative architecture examples

## Candidate Structural Properties

The current theory represents seven candidate structural properties:

- observability
- controllability
- traceability
- reconstructability
- independence
- integrity
- evidence coverage

These properties are provisional.
The theory does not claim that they are complete, mutually independent,
universally necessary, jointly sufficient, or universally monotone in
Structural Assurability.

Four of the seven candidate properties now have dimension-specific,
profile-grounded separating constructions:

- observability,
- evidence coverage,
- traceability, and
- reconstructability.

These establish dimension-specific structural differences
while leaving capability-profile non-equivalence as
a separate obligation.

See [Candidate Structural Properties](theory/10-structural-properties.md).

## Representative Results

The formal examples demonstrate three distinct comparative outcomes:

```text
Case 1: strict dominance
        S_R ≻q S_A ≻q S_O

Case 2: equivalence
        S_O ~q S_A ~q S_R

Case 3: incomparability
        S_V ∥q S_N
```

The formalization also demonstrates a claim-resolution bound.

A world represents a possible state of the relevant reality.
A world space specifies which worlds are admissible for an analysis.
The theory does not require the worlds to differ in architecture;
they can differ in events, internal states, actions, authorization status,
provenance, or any other fact represented by the model.

```text
two admissible worlds
+ same observation
+ different claim truth
→ claim not resolvable
```

If two admissible worlds disagree on the claim
but produce identical observations
under the specified observation model,
that observation model cannot resolve the claim.

In the Case 1 example,
the two worlds differ specifically in this fact:

- World 1: no unauthorized consequential action occurred.
- World 2: an unauthorized consequential action occurred.

The claim is true in the first world and false in the second.
If both worlds nevertheless produce the same observation for the evaluator,
then the observation cannot tell which world they are in.
Therefore it cannot resolve the claim.

These results are assurance-context dependent.
They do not define a universal ranking of architectures.

## Approximation Transfer and Additional Examples

The formalization establishes sufficient conditions for transferring
claim-resolution results between abstract and concrete observation models.

Failure transfer preserves an abstract resolution failure when
claim-disagreeing worlds have admissible concrete realizations that
remain observationally indistinguishable.

Positive resolution transfer uses the reverse relationship:
admissible concrete worlds must be covered by the abstract model,
and concrete observational indistinguishability must imply abstract
observational indistinguishability.

Witness-level transfer requires only the concrete realization of
one abstract resolution-failure witness rather than a global
correspondence between world spaces.

Two additional finite-world examples exercise these results:

- **Precinct vintage:** self-reported labels and independent reference
  checks under explicit assumptions about honesty, authority,
  currency, and verification correctness.
- **Deployment shift:** offline metrics, drift monitoring, and labeled
  production observations under explicit coverage and
  representativeness assumptions.

These examples establish results about specified finite models.
They do **not** establish properties of actual precinct-data pipelines
or deployed classifiers.

See [Approximation Transfer](theory/14-approximation-transfer.md),
[Precinct Vintage](examples/precinct-vintage.md), and
[Deployment Shift](examples/deployment-shift.md).

## Documentation

The documentation is organized into:

- **Theory** - formal concepts, theorems, and modeling limitations.
- **Examples** - representative applications of the Lean theory.
- [**Experiments**](experiments/index.md) - exploratory Python
  experiments testing candidate structural distinctions,
  adversarial assumptions, and claim-resolution limits.

## Authority

The Lean source is authoritative for the formal theory.
