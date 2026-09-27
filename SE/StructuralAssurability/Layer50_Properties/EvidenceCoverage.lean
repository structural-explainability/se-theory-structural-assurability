/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uCoverageElement
/--
An `EvidenceCoverageModel` records which claim-relevant states, behaviors,
events, interfaces, effects, or other elements are exposed by the
evidence-producing structure.
Coverage is represented extensionally rather than as a percentage or scalar
score.
-/
public structure EvidenceCoverageModel
    (System : Type uSystem)
    (CoverageElement : Type uCoverageElement) where
  /-- Whether the system covers the specified evidence element. -/
  covered : System → CoverageElement → Prop
namespace EvidenceCoverageModel
/--
The evidence-coverage profile of a system.
-/
public abbrev profile
    {System : Type uSystem}
    {CoverageElement : Type uCoverageElement}
    (model : EvidenceCoverageModel System CoverageElement)
    (system : System) :
    DimensionProfile CoverageElement :=
  { element | model.covered system element }
end EvidenceCoverageModel
end SE.StructuralAssurability
