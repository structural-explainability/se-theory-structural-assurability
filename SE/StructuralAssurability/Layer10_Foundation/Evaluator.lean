/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

namespace SE.StructuralAssurability

universe uEvaluator uKnowledge uAccess uTrust uCooperation

/--
Conditions under which an evaluator attempts to obtain assurance evidence.

This structure represents the `K` component of the paper's notation:
knowledge, access, trust, and cooperation conditions available to a specified
evaluator.

Resource constraints are deliberately excluded and represented separately by
the `B` component of an assurance context.
-/
public structure EvaluatorConditions
    (Evaluator : Type uEvaluator)
    (Knowledge : Type uKnowledge)
    (Access : Type uAccess)
    (Trust : Type uTrust)
    (Cooperation : Type uCooperation) where
  /-- The evaluator performing the assessment. -/
  evaluator : Evaluator
  /-- Knowledge available to the evaluator. -/
  knowledge : Knowledge
  /-- Access available to the evaluator. -/
  access : Access
  /-- Trust conditions governing available evidence. -/
  trust : Trust
  /-- Cooperation available from relevant parties or systems. -/
  cooperation : Cooperation

end SE.StructuralAssurability
