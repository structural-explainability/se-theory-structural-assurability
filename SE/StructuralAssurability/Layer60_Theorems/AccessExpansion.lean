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
Evaluator conditions `weaker` expand to `stronger` for a system when every
evidence item accessible under `weaker` remains accessible under `stronger`.
The relation is extensional: it does not require the evaluator-condition
carrier itself to possess a numerical or total order.
-/
public abbrev accessExpansion
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {Evaluator : Type uEvaluator}
    {Knowledge : Type uKnowledge}
    {Access : Type uAccess}
    {Trust : Type uTrust}
    {Cooperation : Type uCooperation}
    (accessModel :
      EvidenceAccessModel
        System
        Evidence
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation)
    (system : System)
    (weaker stronger :
      EvaluatorConditions
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation) :
    Prop :=
  ∀ evidence,
    accessModel.accessible system weaker evidence →
    accessModel.accessible system stronger evidence
/--
Access expansion cannot reduce practically obtainable evidence when the
system, resource model, and resource budget are held fixed.
-/
public theorem obtainableEvidence_mono_of_accessExpansion
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
    (weaker stronger :
      EvaluatorConditions
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation)
    (budget : Budget)
    (expansion :
      accessExpansion
        accessModel
        system
        weaker
        stronger) :
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        weaker
        budget
      ⊆
    EvidenceAccessModel.obtainableEvidence
        accessModel
        resourceModel
        system
        stronger
        budget := by
  intro evidence obtainable
  exact ⟨
    expansion evidence obtainable.1,
    obtainable.2
  ⟩
end SE.StructuralAssurability
