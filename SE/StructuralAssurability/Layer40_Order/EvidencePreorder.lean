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
Evidence set `left` is no more capable than evidence set `right` for a claim
when every evidentiary capability enabled by `left` is also enabled by
`right`.
This is the formal counterpart of the manuscript relation
`E₁ ≼ᴱ_C E₂`.
-/
public abbrev evidenceCapabilityLe
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    (left right : EvidenceSet Evidence) :
    Prop :=
  CapabilityModel.capabilities model claim left ⊆
    CapabilityModel.capabilities model claim right
/--
The evidence-capability relation is reflexive.
-/
public theorem evidenceCapabilityLe_refl
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    (evidenceSet : EvidenceSet Evidence) :
    evidenceCapabilityLe model claim evidenceSet evidenceSet := by
  intro capability enabled
  exact enabled
/--
The evidence-capability relation is transitive.
-/
public theorem evidenceCapabilityLe_trans
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    {Capability : Type uCapability}
    (model : CapabilityModel World Evidence Capability)
    (claim : Claim World)
    {first second third : EvidenceSet Evidence}
    (firstLeSecond :
      evidenceCapabilityLe model claim first second)
    (secondLeThird :
      evidenceCapabilityLe model claim second third) :
    evidenceCapabilityLe model claim first third := by
  intro capability enabled
  exact secondLeThird (firstLeSecond enabled)
end SE.StructuralAssurability
