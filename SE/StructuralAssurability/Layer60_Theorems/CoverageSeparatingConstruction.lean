/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer50_Properties.EvidenceCoverage
public import SE.StructuralAssurability.Layer60_Theorems.SeparatingConstruction

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
  uCoverageElement

/-!
# Evidence-coverage-specific separating constructions

Two dimension-locked, profile-grounded difference relations are provided.

- `coverageDifference` requires strict inclusion of evidence-coverage
  profiles between two systems.
- `coverageControlledDifference` requires one named coverage element to
  be uncovered in the lower system and covered in the upper system,
  with identical coverage status for every other element.

The controlled relation implies the general relation.
The converse does not hold in general because the general relation
permits differences involving multiple coverage elements.

The smart constructor combines a coverage-profile difference with
independently established Structural Assurability non-equivalence
to establish evidence-coverage relevance.

## Modeling limitation

The controlled relation isolates a single coverage-element difference
within the specified `EvidenceCoverageModel`. It does not establish
independence from other structural properties.

Neither coverage relation independently establishes a difference in
evidentiary capabilities or claim resolution.

This construction does not derive capability-profile non-equivalence
from evidence-coverage-profile inclusion.
That non-equivalence remains a separate proof obligation.
-/

/--
Dimension-locked, profile-grounded difference relation for evidence coverage.

For `.evidenceCoverage`, the relation requires strict inclusion of
evidence-coverage profiles. For every other dimension, it is `False`.
-/
@[expose] public def coverageDifference
    {System : Type uSystem}
    {CoverageElement : Type uCoverageElement}
    (covModel : EvidenceCoverageModel System CoverageElement) :
    CandidateStructuralDimension → System → System → Prop
  | .evidenceCoverage, lower, upper =>
      EvidenceCoverageModel.profile covModel lower ⊂
        EvidenceCoverageModel.profile covModel upper
  | _, _, _ => False

/--
Controlled evidence-coverage difference for one named coverage element.

The focal element must be uncovered in the lower system and covered
in the upper system. Coverage status must agree for every other element.

The relation is restricted to `.evidenceCoverage`;
for every other dimension, it is `False`.
-/
@[expose] public def coverageControlledDifference
    {System : Type uSystem}
    {CoverageElement : Type uCoverageElement}
    (covModel : EvidenceCoverageModel System CoverageElement)
    (focal : CoverageElement) :
    CandidateStructuralDimension → System → System → Prop
  | .evidenceCoverage, lower, upper =>
      ¬ covModel.covered lower focal ∧
      covModel.covered upper focal ∧
      ∀ element, element ≠ focal →
        (covModel.covered lower element ↔ covModel.covered upper element)
  | _, _, _ => False

/-- `coverageDifference` can only ever witness `.evidenceCoverage`. -/
public theorem coverageDifference_only_evidenceCoverage
    {System : Type uSystem}
    {CoverageElement : Type uCoverageElement}
    (covModel : EvidenceCoverageModel System CoverageElement)
    {dimension : CandidateStructuralDimension}
    {lower upper : System}
    (differs : coverageDifference covModel dimension lower upper) :
    dimension = .evidenceCoverage := by
  cases dimension
  case evidenceCoverage => rfl
  all_goals exact differs.elim

/-- `coverageControlledDifference` can only ever witness `.evidenceCoverage`. -/
public theorem coverageControlledDifference_only_evidenceCoverage
    {System : Type uSystem}
    {CoverageElement : Type uCoverageElement}
    (covModel : EvidenceCoverageModel System CoverageElement)
    (focal : CoverageElement)
    {dimension : CandidateStructuralDimension}
    {lower upper : System}
    (differs : coverageControlledDifference covModel focal dimension lower upper) :
    dimension = .evidenceCoverage := by
  cases dimension
  case evidenceCoverage => rfl
  all_goals exact differs.elim

/--
A controlled evidence-coverage difference implies strict inclusion
of evidence-coverage profiles for the same pair of systems.

The general relation permits differences involving multiple coverage
elements, so the converse does not hold in general.
-/
public theorem coverageControlledDifference_imp_coverageDifference
    {System : Type uSystem}
    {CoverageElement : Type uCoverageElement}
    (covModel : EvidenceCoverageModel System CoverageElement)
    (focal : CoverageElement)
    {lower upper : System}
    (controlled :
      coverageControlledDifference covModel focal .evidenceCoverage lower upper) :
    coverageDifference covModel .evidenceCoverage lower upper := by
  obtain ⟨lowerNotFocal, upperFocal, agreeElsewhere⟩ := controlled
  constructor
  · intro element hmem
    by_cases h : element = focal
    · subst h; exact absurd hmem lowerNotFocal
    · exact (agreeElsewhere element h).mp hmem
  · intro h
    exact lowerNotFocal (h upperFocal)

/--
Constructs an evidence-coverage-specific `SeparatingConstruction` from
strict inclusion of evidence-coverage profiles and independently
established Structural Assurability non-equivalence.

The construction fixes the dimension to `.evidenceCoverage`.
A controlled difference can satisfy its profile-inclusion obligation
through `coverageControlledDifference_imp_coverageDifference`.
-/
public def SeparatingConstruction.ofCoverage
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
    {CoverageElement : Type uCoverageElement}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (covModel : EvidenceCoverageModel System CoverageElement)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreCovered :
      EvidenceCoverageModel.profile covModel lower ⊂
        EvidenceCoverageModel.profile covModel upper)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    SeparatingConstruction model (coverageDifference covModel) where
  dimension := .evidenceCoverage
  context := context
  lower := lower
  upper := upper
  dimensionDiffers := strictlyMoreCovered
  notEquivalent := notEquivalent

/-- The evidence-coverage-specific route to `assuranceRelevantDimension`. -/
public theorem evidenceCoverage_assuranceRelevant_of_profile_difference
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
    {CoverageElement : Type uCoverageElement}
    (model :
      AssurabilityModel
        System World Evidence Capability Evaluator Knowledge Access Trust
        Cooperation Budget)
    (covModel : EvidenceCoverageModel System CoverageElement)
    (context :
      ComparativeContext World Evaluator Knowledge Access Trust Cooperation
        Budget)
    (lower upper : System)
    (strictlyMoreCovered :
      EvidenceCoverageModel.profile covModel lower ⊂
        EvidenceCoverageModel.profile covModel upper)
    (notEquivalent : ¬ assurabilityEquivalent model context lower upper) :
    assuranceRelevantDimension
      model (coverageDifference covModel) .evidenceCoverage :=
  separatingConstruction_establishes_relevance
    model
    (coverageDifference covModel)
    (SeparatingConstruction.ofCoverage
      model covModel context lower upper strictlyMoreCovered notEquivalent)

end SE.StructuralAssurability
