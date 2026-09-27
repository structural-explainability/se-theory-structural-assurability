/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uEvidence uSubject
/--
Ways in which assurance evidence may be independent of the component or actor
whose behavior is being evaluated.
-/
public inductive IndependenceMode where
  | generated
  | preserved
  | corroborated
  deriving DecidableEq, Repr
/--
An `IndependenceModel` records whether evidence is generated, preserved, or
corroborated independently of a specified subject.
The subject may represent a component, actor, operator, provider, or other
entity whose behavior is material to the assurance claim.
-/
public structure IndependenceModel
    (System : Type uSystem)
    (Evidence : Type uEvidence)
    (Subject : Type uSubject) where
  /-- Whether the evidence satisfies the specified independence condition. -/
  independent :
    System →
    Evidence →
    Subject →
    IndependenceMode →
    Prop
namespace IndependenceModel
/--
Evidence independent of a specified subject in a specified mode.
-/
public abbrev independentEvidence
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {Subject : Type uSubject}
    (model : IndependenceModel System Evidence Subject)
    (system : System)
    (subject : Subject)
    (mode : IndependenceMode) :
    DimensionProfile Evidence :=
  { evidence | model.independent system evidence subject mode }
end IndependenceModel
end SE.StructuralAssurability
