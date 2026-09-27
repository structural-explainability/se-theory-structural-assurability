# Instrumented Agent

Instrumentation can make additional claim-relevant distinctions possible.

Consider a claim concerning unauthorized consequential action.

An opaque service may expose evidence that an action occurred while providing
little evidence about:

- who or what initiated the action
- the authorization state
- the execution pathway
- whether relevant evidence could have been altered
- whether consequential-action channels were fully observed

An **instrumented agent** can expose additional runtime evidence concerning
origin, authorization, and execution pathway.

An assurability-oriented architecture can additionally expose or preserve
evidence concerning integrity, coverage, and independent corroboration.

## Example Result

In the formal example, each stronger architecture preserves
the relevant capabilities of the preceding architecture
and adds at least one additional capability.

For the modeled assurance context:

```text
S_R ≻q S_A ≻q S_O
```

This is strict comparative dominance for that claim and context.

It does not establish that any architecture satisfies the claim.
A more assurable architecture may instead provide stronger evidence that the
claim is false.

## Claim-Resolution Bound

The same example also considers two admissible possible worlds:

```text
World 1: no unauthorized consequential action occurred
World 2: an unauthorized consequential action occurred
```

The worlds differ on a fact relevant to the claim.

If the evaluator receives the same observation in both worlds,
that observation cannot determine which world holds and
therefore cannot resolve the claim.

## Source of Truth

The Lean source is authoritative:

- [`Case1_UnauthorizedAction.lean`](../../../SE/StructuralAssurability/Layer90_Examples/Case1_UnauthorizedAction.lean)
- [`Architectures.lean`](../../../SE/StructuralAssurability/Layer90_Examples/Architectures.lean)
- [`Bounds.lean`](../../../SE/StructuralAssurability/Layer30_Core/Bounds.lean)
- [`ConservativeExtension.lean`](../../../SE/StructuralAssurability/Layer60_Theorems/ConservativeExtension.lean)
