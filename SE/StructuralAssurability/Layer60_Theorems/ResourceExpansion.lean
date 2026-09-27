/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer20_Semantics.Accessibility
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
Resource budget `weaker` expands to `stronger` for a system when every
evidence item feasible under `weaker` remains feasible under `stronger`.
The relation is extensional and therefore does not require budgets to possess
a numerical or total order.
-/
public abbrev resourceExpansion
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {Budget : Type uBudget}
    (resourceModel :
      ResourceModel System Evidence Budget)
    (system : System)
    (weaker stronger : Budget) :
    Prop :=
  ∀ evidence,
    resourceModel.feasible system weaker evidence →
    resourceModel.feasible system stronger evidence
/--
Resource expansion cannot reduce practically obtainable evidence when the
system, access model, and evaluator conditions are held fixed.
-/
public theorem obtainableEvidence_mono_of_resourceExpansion
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
    (resourceModel :
      ResourceModel System Evidence Budget)
    (system : System)
    (conditions :
      EvaluatorConditions
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation)
    (weaker stronger : Budget)
    (expansion :
      resourceExpansion
        resourceModel
        system
        weaker
        stronger) :
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        conditions
        weaker
      ⊆
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        conditions
        stronger := by
  intro evidence obtainable
  exact ⟨
    obtainable.1,
    expansion evidence obtainable.2
  ⟩
end SE.StructuralAssurability
