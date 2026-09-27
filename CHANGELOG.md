# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)**
and this project adheres to **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

---

## [Unreleased]

---

## [0.1.0] - 2026-09-27

### Added

- Initial Structural Assurability Lean 4 formalization.
- Layered formal theory architecture with intentionally open extension points:
  - Layer 10: Foundation
  - Layer 20: Semantics
  - Layer 30: Core
  - Layer 40: Order
  - Layer 50: Candidate Structural Properties
  - Layer 60: Theorems
  - Layers 70-80: reserved for future theory
  - Layer 90: Representative Examples
- Foundational formal objects for:
  - admissible world spaces
  - assurance claims
  - evidence sets
  - evaluator conditions
  - comparative assurance contexts
  - system-specific assurance contexts
- Semantic models separating:
  - observation
  - evidence accessibility
  - resource feasibility
  - practically obtainable evidence
  - claim-material evidence
  - evidentiary sufficiency
  - observational indistinguishability
  - claim disagreement
- Core claim-relative Structural Assurability model based on:
  - evidentiary capability maps
  - claim-material capability sets
  - Structural Assurability profiles
  - explicit assurance models holding access, resource, materiality, and
    capability semantics fixed
- Formal claim-resolution criterion over admissible possible worlds.
- Resolution-failure witnesses establishing that a claim cannot be resolved
  when admissible worlds:
  - disagree on claim truth
  - remain observationally indistinguishable
- Evidence-capability preorder with proofs of:
  - reflexivity
  - transitivity
- Comparative Structural Assurability relations for:
  - equivalence
  - non-strict dominance
  - strict dominance
  - incomparability
- Proof that Structural Assurability equivalence is characterized by mutual
  comparative dominance.
- Proof that strict comparative dominance excludes Structural Assurability
  equivalence.
- Proof that incomparable systems cannot be Structural Assurability-equivalent.
- Formal representations of the current seven candidate structural properties:
  - observability
  - controllability
  - traceability
  - reconstructability
  - independence
  - evidence integrity
  - evidence coverage
- Extensional structural-property profiles that avoid imposing unsupported
  numerical scales.
- Separate controllability models for:
  - establishable evaluation conditions
  - performable interventions
- Explicit independence modes for:
  - independent generation
  - independent preservation
  - independent corroboration
- Explicit evidence-integrity threat classes for:
  - alteration
  - fabrication
  - suppression
  - substitution
  - corruption
- Separating-construction formalization for demonstrating that a candidate
  structural dimension contributes to Structural Assurability in at least
  one assurance context.
- Formal access-expansion relation and proof that expanded access cannot
  reduce obtainable evidence when resources are held fixed.
- Formal resource-expansion relation and proof that expanded resources cannot
  reduce obtainable evidence when access conditions are held fixed.
- Claim-material evidence monotonicity under evidence-set inclusion.
- Explicit capability-monotonicity condition rather than assuming that
  additional evidence always produces additional evidentiary capability.
- Conservative-extension witnesses establishing strict comparative Structural
  Assurability when an architecture:
  - preserves all existing claim-material evidentiary capabilities
  - adds at least one additional capability
- Representative architecture examples covering:
  - opaque service architectures
  - instrumented agent architectures
  - assurability-oriented architectures
  - internal-visibility architectures
  - independent-evidence architectures
- Formal representative cases demonstrating:
  - strict comparative dominance for an unauthorized consequential-action
    assurance context
  - Structural Assurability equivalence for an externally resolvable
    output-property claim
  - Structural Assurability incomparability between internal visibility and
    independently generated evidence
  - failure of claim resolution when an opaque observation surface collapses
    claim-disagreeing possible worlds
- Public Lean module surface through `SE.lean` and layered
  `SE.StructuralAssurability` aggregators.
- Parallel `SETest` module hierarchy with smoke tests across all implemented
  layers.
- Intentional distinction between:
  - API definitions whose implementations remain encapsulated
  - transparent mathematical definitions whose bodies are part of the public
    theory
- Lean documentation and module comments recording the logical scope and
  limits of each theory layer.
- Initial repository metadata, release infrastructure, documentation
  configuration, and reference-validation support.

---

## Notes on versioning and releases

- We use **SemVer**:
  - **MAJOR** – breaking changes
  - **MINOR** – backward-compatible additions
  - **PATCH** – fixes, documentation, tooling
- Versions are driven by git tags. Tag `vX.Y.Z` to release.
- Docs are deployed per version tag and aliased to **latest**.

## Release Procedure (Required)

Follow these steps exactly when creating a new release.

### One-Time Zenodo Authorization

1. Sign in to Zenodo.
2. Open your profile menu in the upper-right.
3. Select GitHub.
4. Click Sync now.
5. Find structural-explainability/ this repo.
6. Turn on the repository toggle/slider.
7. Refresh the page and confirm it appears as enabled.
8. Zenodo will ingest future GitHub Releases from this repo.

### Task 1. Update release metadata (manual edits)

1.1. CITATION.cff: update version and date-released
1.2. lakefile.toml: update version
1.3. CHANGELOG.md: add section, move unreleased entries, update links
1.4. pyproject.toml: update version (near top of the file)

### Task 2. Validate

Run:

```powershell
# situate Python repository
.\sit.ps1

# Update GitHub Actions and pin all action references to immutable SHAs
uvx gha-tools autoupdate --pin=all --write .github/workflows
uvx gha-tools autoupdate --pin=all --write .pre-commit-config.yaml

# Then audit the resulting GitHub configuration for security findings
uvx zizmor@latest .github/

# validate files
uvx cffconvert --validate
uvx se-manifest-schema validate-manifest --strict

# format markdown
npx markdownlint-cli2 --fix

# prepare lean
.\rel.ps1

# create lean docbuild
.\docs.ps1
```

Review all generated and modified files before committing.

### Task 3. Commit and Push

```shell
git add -A
git commit -m "Prep X.Y.Z"
git push -u origin main
```

Verify that all required GitHub Actions complete successfully,
including the combined Zensical and Lean API documentation deployment.

### Task 4. Tag and Push the Release

After the required GitHub Actions succeed:

```shell
git tag vX.Y.Z -m "X.Y.Z"
git push origin vX.Y.Z
```

Create GitHub Release after pushing tag, for example
with a command like this:

```shell
gh release create v0.1.0 --verify-tag --title "0.1.0"  --generate-notes
```

### Task 5. After tagging, verify tag consistency

```shell
uvx se-manifest-schema check-version --require-tag
```

Confirms CITATION.cff version matches the pushed git tag.
Run this after `git push origin vX.Y.Z`; it will fail before that point.

## Only As Needed (delete a tag)

```shell
git tag -d vX.Z.Y
git push origin :refs/tags/vX.Z.Y
```

## Links

[Unreleased]: https://github.com/structural-explainability/se-theory-structural-assurability/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/structural-explainability/se-theory-structural-assurability/releases/tag/v0.1.0

<!-- markdownlint-enable MD024 -->
