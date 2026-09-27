# Decisions

This file records durable design decisions for the Structural Assurability
formalization. Current repository organization and usage belong in `README.md`.

## Theory Structure

- Theory is organized by dependency layer:
  - 10 Foundation
  - 20 Semantics
  - 30 Core
  - 40 Order
  - 50 Candidate Structural Properties
  - 60 General Theorems
  - 90 Representative Examples
- Layers 70 and 80 are intentionally unassigned to preserve room for future theory.
- Lower layers must not depend on higher layers.
- Example modules explicitly import the lower-level theory they directly use rather
  than relying on accidental transitive imports.

## Formal Objects

- `public def` is used when an API name should be public but its implementation
  should remain encapsulated.
- `public abbrev` is used for mathematical definitions whose bodies are part of
  the public theory and are intentionally unfoldable by downstream proofs.

## Assurability Model

- Structural Assurability is claim-relative and context-relative.
- Assurability is represented through sets of claim-material evidentiary
  capabilities, not a universal scalar score.
- Obtainable evidence, claim-material evidence, evidentiary capability, and
  downstream evidentiary sufficiency remain distinct concepts.
- Comparative assurability permits equivalence, dominance, strict dominance,
  and incomparability.

## Structural Properties

- Observability, controllability, traceability, reconstructability,
  independence, integrity, and evidence coverage are candidate structural
  properties.
- The candidate set is provisional.
- The theory does not assume the properties are complete, independent,
  universally necessary, jointly sufficient, or universally monotone in
  assurability.
- Contribution is established through separating constructions.

## Examples

Representative examples exercise the theory.
They demonstrate that different assurance contexts can yield:

- strict comparative dominance
- assurability equivalence
- assurability incomparability
- claim-resolution failure through observational indistinguishability

The examples do not establish a general ranking of architectures.
