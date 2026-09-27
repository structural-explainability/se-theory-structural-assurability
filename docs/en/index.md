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

A world is any admissible possible state of the relevant reality.
The theory does not require the worlds to differ in architecture;
they can differ in events, internal states, actions, authorization status,
provenance, or any other fact represented by the model.

```text
two admissible worlds
+ same observation
+ different claim truth
→ claim not resolvable
```

That is, if the evidence cannot distinguish between a world
where the claim holds and a world where it does not,
then that evidence is insufficient to determine the claim.

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

## Documentation

The documentation is organized into:

- **Theory** - formal concepts and results
- **Examples** - representative applications of the theory
- **Mappings** - relationships to external assurance and evaluation frameworks

The Lean source is authoritative for the formal theory.
