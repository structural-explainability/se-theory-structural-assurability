/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer10_Foundation.Claim
public import SE.StructuralAssurability.Layer10_Foundation.Evaluator

namespace SE.StructuralAssurability

universe
  uSystem
  uWorld
  uEvaluator
  uKnowledge
  uAccess
  uTrust
  uCooperation
  uBudget

/--
A comparative assurance context corresponds to the paper's

`q = (C, K, B)`,

where the system itself is deliberately omitted so that multiple systems can
be compared under the same claim, evaluator conditions, and resource budget.

No semantics are yet assigned to the budget carrier. Later layers determine
how resource constraints affect evidence obtainability.
-/
public structure ComparativeContext
    (World : Type uWorld)
    (Evaluator : Type uEvaluator)
    (Knowledge : Type uKnowledge)
    (Access : Type uAccess)
    (Trust : Type uTrust)
    (Cooperation : Type uCooperation)
    (Budget : Type uBudget) where
  /-- Claim being evaluated. -/
  claim : Claim World
  /-- Evaluator conditions held fixed for the comparison. -/
  conditions :
    EvaluatorConditions Evaluator Knowledge Access Trust Cooperation
  /-- Resource budget held fixed for the comparison. -/
  budget : Budget

/--
A system-specific assurance context corresponds to the paper's

`Q = (S, C, K, B)`.

It combines a system with a comparative context. Structural Assurability is
therefore not modeled as an unconditional property of a system.
-/
public structure AssuranceContext
    (System : Type uSystem)
    (World : Type uWorld)
    (Evaluator : Type uEvaluator)
    (Knowledge : Type uKnowledge)
    (Access : Type uAccess)
    (Trust : Type uTrust)
    (Cooperation : Type uCooperation)
    (Budget : Type uBudget) where
  /-- System being evaluated. -/
  system : System
  /-- Comparative context applied to the system. -/
  comparative :
    ComparativeContext
      World
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation
      Budget

end SE.StructuralAssurability
