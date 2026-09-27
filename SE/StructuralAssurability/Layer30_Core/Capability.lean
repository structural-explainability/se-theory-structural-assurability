/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer10_Foundation.Context
public import SE.StructuralAssurability.Layer20_Semantics.Accessibility
public import SE.StructuralAssurability.Layer20_Semantics.Materiality

namespace SE.StructuralAssurability

universe
  uSystem
  uWorld
  uEvidence
  uCapability
  uEvaluator
  uKnowledge
  uAccess
  uTrust
  uCooperation
  uBudget

/--
A `CapabilityModel` specifies which evidentiary capabilities are enabled by
an evidence set for a particular assurance claim.

This is the formal counterpart of the manuscript's capability map

`Γ_C(E)`.

The model represents fixed evidentiary and inferential standards. It does not
assume that capabilities are numerical, totally ordered, or monotone under
evidence-set inclusion.
-/
public structure CapabilityModel
    (World : Type uWorld)
    (Evidence : Type uEvidence)
    (Capability : Type uCapability) where
  /-- Whether an evidence set enables the capability for the claim. -/
  enabled :
    Claim World →
    EvidenceSet Evidence →
    Capability →
    Prop

namespace CapabilityModel

/--
The set of evidentiary capabilities enabled by an evidence set for a claim.

This is the set-valued interpretation of `Γ_C(E)`.
-/
public abbrev capabilities
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    (evidenceSet : EvidenceSet Evidence) :
    Set Capability :=
  { capability | model.enabled claim evidenceSet capability }

/--
The claim-material evidentiary capabilities available from a system under a
comparative assurance context.

The construction proceeds in three explicit stages:

1. obtain evidence permitted by evaluator conditions and resource constraints;
2. retain only evidence material to the claim; and
3. determine which evidentiary capabilities that evidence enables.

This is the formal counterpart of the manuscript's `G_q(S)`.
-/
public abbrev systemCapabilities
    {System : Type uSystem}
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    {Evaluator : Type uEvaluator}
    {Knowledge : Type uKnowledge}
    {Access : Type uAccess}
    {Trust : Type uTrust}
    {Cooperation : Type uCooperation}
    {Budget : Type uBudget}
    (capabilityModel : CapabilityModel World Evidence Capability)
    (materiality : MaterialityStandard World Evidence)
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget) :
    Set Capability :=
  let obtainable :=
    EvidenceAccessModel.obtainableEvidence
      accessModel
      resourceModel
      system
      context.conditions
      context.budget
  let material :=
    MaterialityStandard.claimMaterialEvidence
      materiality
      context.claim
      obtainable
  capabilities
    capabilityModel
    context.claim
    material

end CapabilityModel

end SE.StructuralAssurability
