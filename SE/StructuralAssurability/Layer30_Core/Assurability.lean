/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer30_Core.Capability

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
An `AssurabilityProfile` is the set of claim-material evidentiary capabilities
available under a specified assurance model and comparative context.

The profile is intentionally set-valued. Structural Assurability is therefore
not assumed to be a universal scalar score.
-/
public abbrev AssurabilityProfile
    (Capability : Type uCapability) :=
  Set Capability

/--
An `AssurabilityModel` fixes the semantic machinery used when comparing
systems:

- evaluator access conditions;
- resource feasibility;
- claim materiality; and
- evidentiary capability semantics.

For comparative analysis these standards are held fixed while systems vary.
-/
public structure AssurabilityModel
    (System : Type uSystem)
    (World : Type uWorld)
    (Evidence : Type uEvidence)
    (Capability : Type uCapability)
    (Evaluator : Type uEvaluator)
    (Knowledge : Type uKnowledge)
    (Access : Type uAccess)
    (Trust : Type uTrust)
    (Cooperation : Type uCooperation)
    (Budget : Type uBudget) where
  /-- Evidence-access semantics. -/
  accessModel :
    EvidenceAccessModel
      System
      Evidence
      Evaluator
      Knowledge
      Access
      Trust
      Cooperation
  /-- Resource-feasibility semantics. -/
  resourceModel :
    ResourceModel System Evidence Budget
  /-- Claim-materiality semantics. -/
  materiality :
    MaterialityStandard World Evidence
  /-- Evidentiary-capability semantics. -/
  capabilityModel :
    CapabilityModel World Evidence Capability

namespace AssurabilityModel

/--
The Structural Assurability profile of a system under a comparative assurance
context.

This corresponds to the manuscript's `G_q(S)`: the set of claim-material
evidentiary capabilities enabled by practically obtainable evidence.
-/
public abbrev profile
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
    (model :
      AssurabilityModel
        System
        World
        Evidence
        Capability
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
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
    AssurabilityProfile Capability :=
  CapabilityModel.systemCapabilities
    model.capabilityModel
    model.materiality
    model.accessModel
    model.resourceModel
    system
    context

end AssurabilityModel

/--
The claim-relative Structural Assurability of a system under fixed semantic
standards and a specified comparative assurance context.

The result is an `AssurabilityProfile`, not a scalar.

This definition provides the formal object represented schematically in the
paper by `A(S,C,K,B)` while preserving the more precise capability-set
interpretation `G_q(S)`.
-/
public abbrev structuralAssurability
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
    (model :
      AssurabilityModel
        System
        World
        Evidence
        Capability
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
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
    AssurabilityProfile Capability :=
  model.profile system context

end SE.StructuralAssurability
