/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all
public import SE.StructuralAssurability.Layer40_Order.EvidencePreorder
public import SE.StructuralAssurability.Layer40_Order.Equivalence
public import SE.StructuralAssurability.Layer40_Order.Dominance
public import SE.StructuralAssurability.Layer40_Order.Incomparability
/-!
# Layer 40: Order
Order-theoretic structure for Structural Assurability.
This layer formalizes:
- the evidence-capability preorder;
- evidentiary and assurability equivalence;
- comparative assurability;
- strict comparative dominance; and
- incomparability.
The relations are transparent mathematical definitions. Their order
properties are established by public theorems rather than assumed.
No total ordering or scalar assurability score is introduced.

See paper:
  E₁ ≼ᴱ_C E₂
  S₁ ≽q S₂
  S₁ ~q S₂
  S₁ ≻q S₂
  S₁ ∥q S₂

Here, prove rather than merely state:
- evidence-capability comparison is reflexive
- evidence-capability comparison is transitive
- comparative assurability is a preorder
- equivalence is capability-set equality
- strict dominance is proper containment
- incomparability really means neither system contains the other's capability set
- equality of raw evidence artifacts is not required for assurability equivalence

-/
