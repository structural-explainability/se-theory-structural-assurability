/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer10_Foundation.Claim
public import SE.StructuralAssurability.Layer10_Foundation.Evidence

namespace SE.StructuralAssurability

universe uWorld uEvidence

/--
A `MaterialityStandard` specifies whether an evidence item is material to a
particular assurance claim.

Materiality is deliberately external to the structural evidence model.
Whether an observation legitimately bears on a claim is an evidentiary and
inferential question rather than, by itself, a structural property.
-/
public structure MaterialityStandard
    (World : Type uWorld)
    (Evidence : Type uEvidence) where
  /-- Whether the evidence is material to the claim. -/
  material : Claim World → Evidence → Prop

namespace MaterialityStandard

/--
Restrict an evidence set to evidence material to a particular claim.

This is the formal counterpart of the manuscript's claim-material evidence
set `E_q^C(S)`.
-/
public abbrev claimMaterialEvidence
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    (standard : MaterialityStandard World Evidence)
    (claim : Claim World)
    (evidenceSet : EvidenceSet Evidence) :
    EvidenceSet Evidence :=
  { evidence |
      evidence ∈ evidenceSet ∧
      standard.material claim evidence }

end MaterialityStandard

end SE.StructuralAssurability
