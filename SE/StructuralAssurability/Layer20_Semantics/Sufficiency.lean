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
A `SufficiencyStandard` specifies when an evidence set is sufficient for a
particular assurance claim under an applicable evidentiary and inferential
standard.

Sufficiency is represented explicitly but remains downstream from structural
obtainability. Structural Assurability does not infer sufficiency merely from
the existence or quantity of evidence.
-/
public structure SufficiencyStandard
    (World : Type uWorld)
    (Evidence : Type uEvidence) where
  /-- Whether the evidence set is sufficient for the claim. -/
  sufficient : Claim World → EvidenceSet Evidence → Prop

namespace SufficiencyStandard

/--
Evaluate whether a particular evidence set satisfies the stated sufficiency
standard for a claim.
-/
public abbrev isSufficient
    {World : Type uWorld}
    {Evidence : Type uEvidence}
    (standard : SufficiencyStandard World Evidence)
    (claim : Claim World)
    (evidenceSet : EvidenceSet Evidence) :
    Prop :=
  standard.sufficient claim evidenceSet

end SufficiencyStandard

end SE.StructuralAssurability
