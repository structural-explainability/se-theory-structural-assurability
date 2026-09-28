# Formal Theory: Structural Assurability

[![DOI](https://zenodo.org/badge/1391092536.svg)](https://doi.org/10.5281/zenodo.23003559)
[![Docs Site](https://img.shields.io/badge/docs-site-blue?logo=github)](https://structural-explainability.github.io/se-theory-structural-assurability/)
[![Repo](https://img.shields.io/badge/repo-GitHub-black?logo=github)](https://github.com/structural-explainability/se-theory-structural-assurability)
[![Tooling](https://img.shields.io/badge/python-3.15%2B-blue?logo=python)](./pyproject.toml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)

[![CI-Lean](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/ci-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/ci-lean.yml)
[![CI](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/ci-python-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/ci-python-zensical.yml)
[![Docs](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/deploy-zensical-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/deploy-zensical-lean.yml)
[![Links](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/links.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-structural-assurability/actions/workflows/links.yml)
[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-brightgreen.svg)](https://github.com/structural-explainability/se-theory-structural-assurability/security)

> Lean 4 formalization of Structural Explainability's
> Structural Assurability theory.

For full documentation, see [`docs/en/index.md`](./docs/en/index.md).

## Claim-Relative Assurance Limitation

If two realizable, admissible situations disagree on a claim
but produce identical observations under a specified observation model,
that observation model cannot resolve the claim.

Our approximation-transfer results establish explicit conditions
under which such a finding survives the move
from an abstract model to a richer one.

## Authority

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Reference artifacts under `reference/` declare the repository-owned
classification, traceability, and export intent for the Lean public surface.

Generated artifacts under `data/*/` are outputs.
They do not define theory semantics independently of Lean or the reference artifacts.

The reusable `se-theory-reference-kit` owns the generic validation,
cataloging, inspection, and export machinery.
This repository owns its Lean source, reference declarations, and
generated artifacts.

## Repository Organization

```text
SE/                     Lean authoritative theory
SETest/                 Lean verification surface
reference/              declared formal/reference intent
data/                    generated outputs, if/when needed
docs/en/                 human-readable theory documentation
```

## Theory Layers

```text
10  Foundation
20  Semantics
30  Core
40  Order
50  Candidate structural properties
60  General theorems
90  Representative examples
```

Example modules should declare the lower-level theory they directly depend on
rather than assuming transitive imports.

## Import

Downstream Lean projects should import the public surface:

```text
import SE
```

## Dependencies

The Structural Assurability formalization currently has no required
cross-repository Lean theory dependencies.

Repository reference validation and export tooling is provided by
`se-theory-reference-kit`.

## Reference Configuration

The theory-reference workflow is configured by:

```text
reference/theory-reference.toml
```

That file declares this repository's Lean public modules,
reference artifact layout, export targets, and validation commands.
Public symbols are declared in the reference artifacts.

## Map

```text
Paper concept                         Theory repo destination

Assurance context                     Layer10_Foundation / Context
System + claim                        Layer10_Foundation
Evidence                              Layer10_Foundation
Claim materiality                     Layer20_Semantics
Obtainable evidence                   Layer20_Semantics
Evidentiary capability Γ_C            Layer30_Core
Assurability A(S,C,K,B)               Layer30_Core
Evidence-capability preorder          Layer40_Order
Equivalence                           Layer40_Order
Dominance / incomparability           Layer40_Order
Candidate structural properties       Layer50_Properties
Access/resource propositions          Layer60_Theorems
Separating constructions              Layer60_Theorems
Architectural cases                   Layer90_Examples
```

## Lean Formal Objects

Formal objects are either:

- API names whose implementations should remain hidden, defined with `public def`
- mathematical definitions whose bodies are part of the public theory,
  defined with `public abbrev`, such as:
  `world`,
  `indistinguishable`,
  `claimDisagreement`,
  `admissiblyIndistinguishable`,
  `claimResolvedBy`,
  `feasibleEvidence`,
  `accessibleEvidence`,
  `obtainableEvidence`,
  `claimMaterialEvidence`,
  `isSufficient`,
  `capabilities`,
  `systemCapabilities`,
  `profile`, and
  `structuralAssurability`.

This distinction is intentional.
Downstream theorem layers may unfold mathematical definitions,
while implementation details of ordinary API definitions remain encapsulated.

## Examples

Three examples come directly from the associated paper's application section:

- unauthorized consequential action → strict dominance
- externally observable output property → equivalence
- internal visibility versus independent evidence → incomparability

```text
Case 1: strict dominance
        S_R ≻q S_A ≻q S_O

Case 2: equivalence
        S_O ~q S_A ~q S_R

Case 3: incomparability
        S_V ∥q S_N

and the indistinguishability result:

two admissible worlds
+ same obtainable observation
+ different claim truth
→ claim not resolvable
```

Note: For an existential/counterexample-style theorem,
explicit witnesses may be better and more readable
than asking elaboration to infer them.

## Additional Examples

### Two-sided approximation transfer

`ApproximationTransfer.lean` establishes conditions for transferring both
resolution and resolution-failure results between abstract and concrete models.
It also supports the weaker approach of realizing one particular failure witness
without constructing a global correspondence.

### Precinct vintage

`PrecinctVintage.lean` demonstrates why a self-reported vintage label cannot
establish dataset currency when inaccurate labels are admissible.
It formalizes the conditions under which labels and independent reference checks
can resolve that claim, including explicit counterexamples
when assumptions are dropped.

### Deployment shift

`DeploymentShift.lean` provides an independent example.
Offline accuracy metrics, drift monitoring and partial production labeling
can all leave a deployment-accuracy claim unresolved.
It also establishes resolution under
specified coverage or representativeness assumptions.

> Note: Global failure transfer supplies a witness-level realization,
> but we have not formally established that the
> witness-level condition is strictly weaker.

## Developer

- Maintain `lakefile.toml` and `lean-toolchain`.

## Command Reference

<details>
<summary>Show command reference</summary>

### In a machine terminal

Open a machine terminal where you want the project:

```shell
git clone https://github.com/structural-explainability/se-theory-structural-assurability

cd se-theory-structural-assurability
code .
```

### In a VS Code terminal

Use VS Code Menu:
View / Command Palette / `Developer: Reload Window` to refresh.

```pwsh
.\rel.ps1
```

```shell
# save progress
git add -A
git commit -m "update"
git push -u origin main
```

### Inspect Theory-Reference Commands

```shell
uv run --locked se-theory-reference --help
uv run --locked se-theory-reference validate --help
uv run --locked se-theory-reference export --help
uv run --locked se-theory-reference catalog --help
uv run --locked se-theory-reference inspect --help
```

### Repair Dependency State

Use only when the normal update and build commands cannot repair the workspace:

```powershell
Remove-Item -Recurse -Force .\.lake\packages\mathlib `
    -ErrorAction SilentlyContinue

Remove-Item -Force .\lake-manifest.json `
    -ErrorAction SilentlyContinue

lake update
lake exe cache get
```

</details>

## Citation

[CITATION.cff](./CITATION.cff)

## License

[MIT](./LICENSE)

## Repository Manifest

[SE_MANIFEST.toml](./SE_MANIFEST.toml)
