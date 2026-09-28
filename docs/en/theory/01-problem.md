# Problem

Structural Assurability addresses a question that arises before an assurance
argument can legitimately rely on evidence:

> Can the evaluator obtain evidence capable of making the distinctions required
> to evaluate the specified claim?

A system may perform correctly while exposing little evidence about why,
how, or under what conditions an outcome occurred.
Another system may expose additional evidence
but still fail to provide evidence material to the claim being evaluated.

Structural Assurability therefore treats evidence availability and
evidentiary capability as properties of the system,
its evidence-producing environment, and the evaluator's conditions.

The theory is **claim-relative**.
It does not assign systems a universal assurability score.

## Source of Truth

The Lean formalization is authoritative.

- [Assurability.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/Assurability.lean)
- [Capability.lean](https://github.com/structural-explainability/se-theory-structural-assurability/blob/main/SE/StructuralAssurability/Layer30_Core/Capability.lean)
