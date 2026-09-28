# Black-Box Conversation

A black-box system may expose enough evidence to evaluate some claims while
providing little evidence about internal execution.

For example, an evaluator may observe:

- the input provided to the system
- the output returned by the system
- limited request metadata

For a claim that can be resolved entirely from the externally visible output,
additional internal evidence may provide no additional claim-material
capability.

This illustrates an important property of Structural Assurability:

> More instrumentation does not imply greater assurability for every claim.

## Example Result

In the formal output-property example, the capability model treats
**externally returned output** as the only claim-material evidence.

The opaque service, instrumented agent, and assurability-oriented architecture
therefore enable the same modeled output-classification capability
for that assurance context.

The example establishes **equality of capability profiles**.
It does **not** prove that the observed output
resolves a nontrivial output-property claim.

```text
S_O ~q S_A ~q S_R
```

This is **claim-relative equivalence**.
It does **not** imply that the architectures are equivalent for other claims.

## Source of Truth

The Lean source is authoritative:

- [`Case2_OutputProperty.lean`](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer90_Examples/Case2_OutputProperty.lean)
- [`Architectures.lean`](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer90_Examples/Architectures.lean)
- [`Equivalence.lean`](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer40_Order/Equivalence.lean)
