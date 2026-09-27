/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all
public import SE.StructuralAssurability.Layer90_Examples.Architectures
public import SE.StructuralAssurability.Layer90_Examples.Case1_UnauthorizedAction
public import SE.StructuralAssurability.Layer90_Examples.Case2_OutputProperty
public import SE.StructuralAssurability.Layer90_Examples.Case3_Incomparability
/-!
# Layer 90: Examples
Representative applications of Structural Assurability.
The examples instantiate the abstract theory with simplified architectures
and assurance contexts corresponding to the manuscript cases.
They demonstrate three distinct outcomes permitted by the theory:
- strict comparative dominance;
- assurability equivalence; and
- assurability incomparability.
The examples are not rankings of architecture classes.
Each result is relative to the stated assurance claim, evidence model,
evaluator conditions, and resource constraints.
Case 1 additionally illustrates the indistinguishable-world resolution
bound: an observation surface that collapses claim-disagreeing admissible
worlds cannot resolve the claim.
The examples introduce no new foundational semantics. Their purpose is to
exercise the theory already defined in Layers 10-60.
-/
