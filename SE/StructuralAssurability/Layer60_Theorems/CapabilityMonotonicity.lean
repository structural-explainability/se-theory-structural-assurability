/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer30_Core.Capability
namespace SE.StructuralAssurability
universe uWorld uEvidence uCapability
/--
A capability model is monotone when preserving and adding evidence cannot
remove an evidentiary capability already enabled by the smaller evidence set.
This is an explicit additional assumption, not a property imposed on every
`CapabilityModel`.
-/
public abbrev capabilityMonotone
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model :
      CapabilityModel World Evidence Capability) :
    Prop :=
  ∀ (claim : Claim World)
    {left right : EvidenceSet Evidence},
    left ⊆ right →
    CapabilityModel.capabilities model claim left ⊆
      CapabilityModel.capabilities model claim right
/--
Claim-material filtering is monotone with respect to evidence-set inclusion.
Adding obtainable evidence cannot remove an already present material evidence
item when the claim and materiality standard are fixed.
-/
public theorem claimMaterialEvidence_mono
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    (materiality :
      MaterialityStandard World Evidence)
    (claim : Claim World)
    {left right : EvidenceSet Evidence}
    (subset : left ⊆ right) :
    MaterialityStandard.claimMaterialEvidence
        materiality
        claim
        left
      ⊆
    MaterialityStandard.claimMaterialEvidence
        materiality
        claim
        right := by
  intro evidence material
  exact ⟨
    subset material.1,
    material.2
  ⟩
/--
Under a monotone capability model, enlarging an evidence set cannot reduce
the capabilities enabled by its claim-material subset.
This is non-strict monotonicity only. Additional evidence may add no new
claim-material capability.
-/
public theorem claimMaterialCapabilities_mono
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (capabilityModel :
      CapabilityModel World Evidence Capability)
    (materiality :
      MaterialityStandard World Evidence)
    (monotone :
      capabilityMonotone capabilityModel)
    (claim : Claim World)
    {left right : EvidenceSet Evidence}
    (subset : left ⊆ right) :
    CapabilityModel.capabilities
        capabilityModel
        claim
        (MaterialityStandard.claimMaterialEvidence
          materiality
          claim
          left)
      ⊆
    CapabilityModel.capabilities
        capabilityModel
        claim
        (MaterialityStandard.claimMaterialEvidence
          materiality
          claim
          right) := by
  apply monotone claim
  exact claimMaterialEvidence_mono
    materiality
    claim
    subset
end SE.StructuralAssurability
