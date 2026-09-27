/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all

public import SE.StructuralAssurability.Layer30_Core.Capability
public import SE.StructuralAssurability.Layer30_Core.Assurability
public import SE.StructuralAssurability.Layer30_Core.Bounds

/-!
# Layer 30: Core

Core Structural Assurability objects.

This layer formalizes:

- evidentiary capability as `Γ_C(E)`;
- the system capability set corresponding to `G_q(S)`;
- a fixed model of access, resources, materiality, and capability semantics;
- Structural Assurability as a claim-relative capability profile; and
- a resolution bound based on admissible indistinguishable worlds.

No scalar assurability score is introduced.
-/
