/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer10_Foundation.Evaluator
public import SE.StructuralAssurability.Layer10_Foundation.Evidence
public import SE.StructuralAssurability.Layer20_Semantics.Resources

namespace SE.StructuralAssurability

universe
  uSystem
  uEvidence
  uEvaluator
  uKnowledge
  uAccess
  uTrust
  uCooperation
  uBudget

/--
An `EvidenceAccessModel` specifies which evidence items are accessible to an
evaluator under specified knowledge, access, trust, and cooperation
conditions.

Accessibility is distinct from resource feasibility. Evidence may be
accessible in principle while still being infeasible to obtain within the
available resource budget.
-/
public structure EvidenceAccessModel
    (System : Type uSystem)
    (Evidence : Type uEvidence)
    (Evaluator : Type uEvaluator)
    (Knowledge : Type uKnowledge)
    (Access : Type uAccess)
    (Trust : Type uTrust)
    (Cooperation : Type uCooperation) where
  /-- Whether the evaluator can access the evidence. -/
  accessible :
    System →
    EvaluatorConditions Evaluator Knowledge Access Trust Cooperation →
    Evidence →
    Prop

namespace EvidenceAccessModel

/--
The evidence accessible to an evaluator under specified evaluator conditions.
-/
public abbrev accessibleEvidence
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {Evaluator : Type uEvaluator}
    {Knowledge : Type uKnowledge}
    {Access : Type uAccess}
    {Trust : Type uTrust}
    {Cooperation : Type uCooperation}
    (model :
      EvidenceAccessModel
        System
        Evidence
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation)
    (system : System)
    (conditions :
      EvaluatorConditions Evaluator Knowledge Access Trust Cooperation) :
    EvidenceSet Evidence :=
  { evidence | model.accessible system conditions evidence }

/--
The evidence practically obtainable from or about a system under evaluator
conditions `K` and resource constraints `B`.

An evidence item is practically obtainable exactly when it is both:

1. accessible under the evaluator conditions; and
2. feasible under the applicable resource budget.

This is the formal counterpart of the manuscript's `E_q(S)` before
claim-material filtering is applied.
-/
public abbrev obtainableEvidence
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {Evaluator : Type uEvaluator}
    {Knowledge : Type uKnowledge}
    {Access : Type uAccess}
    {Trust : Type uTrust}
    {Cooperation : Type uCooperation}
    {Budget : Type uBudget}
    (accessModel :
      EvidenceAccessModel
        System
        Evidence
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation)
    (resourceModel : ResourceModel System Evidence Budget)
    (system : System)
    (conditions :
      EvaluatorConditions Evaluator Knowledge Access Trust Cooperation)
    (budget : Budget) :
    EvidenceSet Evidence :=
  { evidence |
      accessModel.accessible system conditions evidence ∧
      resourceModel.feasible system budget evidence }

end EvidenceAccessModel

end SE.StructuralAssurability
