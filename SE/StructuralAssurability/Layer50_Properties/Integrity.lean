/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uEvidence
/--
Threats to assurance-evidence integrity explicitly represented by the current
Structural Assurability model.
-/
public inductive EvidenceIntegrityThreat where
  | alteration
  | fabrication
  | suppression
  | substitution
  | corruption
  deriving DecidableEq, Repr
/--
An `IntegrityModel` records whether alteration, fabrication, suppression,
substitution, or corruption of an evidence item can be detected or prevented
by the evidence-producing structure.
The model concerns structural protection and detection capability. It does
not assert that the evidence is substantively valid or sufficient.
-/
public structure IntegrityModel
    (System : Type uSystem)
    (Evidence : Type uEvidence) where
  /-- Whether the system detects or prevents the specified evidence-integrity threat. -/
  detectsOrPrevents :
    System →
    Evidence →
    EvidenceIntegrityThreat →
    Prop
namespace IntegrityModel
/--
Evidence protected against a specified integrity threat.
-/
public abbrev protectedEvidence
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    (model : IntegrityModel System Evidence)
    (system : System)
    (threat : EvidenceIntegrityThreat) :
    DimensionProfile Evidence :=
  { evidence | model.detectsOrPrevents system evidence threat }
end IntegrityModel
end SE.StructuralAssurability
