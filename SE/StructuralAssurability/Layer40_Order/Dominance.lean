/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer40_Order.Equivalence
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
System `left` is at least as assurable as system `right` under a fixed model
and comparative assurance context when every claim-material evidentiary
capability available from `right` is also available from `left`.
This is the formal counterpart of the manuscript relation `S₁ ≽q S₂`.
The direction is intentionally reversed relative to ordinary set inclusion:
`left` is at least as assurable as `right` exactly when
`profile(right) ⊆ profile(left)`.
-/
public abbrev atLeastAsAssurable
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (left right : System) :
    Prop :=
  structuralAssurability model right context ⊆
    structuralAssurability model left context
/--
Comparative assurability is reflexive.
-/
public theorem atLeastAsAssurable_refl
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (system : System) :
    atLeastAsAssurable model context system system := by
  intro capability enabled
  exact enabled
/--
Comparative assurability is transitive.
Together with reflexivity, this establishes a preorder on systems under a
fixed assurance model and comparative context.
-/
public theorem atLeastAsAssurable_trans
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    {first second third : System}
    (firstGeSecond :
      atLeastAsAssurable model context first second)
    (secondGeThird :
      atLeastAsAssurable model context second third) :
    atLeastAsAssurable model context first third := by
  intro capability enabled
  exact firstGeSecond (secondGeThird enabled)
/--
Strict comparative assurability holds when `left` is at least as assurable
as `right`, but `right` is not at least as assurable as `left`.
Because comparative assurability is capability-set containment, this is
proper containment of the corresponding Structural Assurability profiles.
This is the formal counterpart of `S₁ ≻q S₂`.
-/
public abbrev strictlyMoreAssurable
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (left right : System) :
    Prop :=
  atLeastAsAssurable model context left right ∧
    ¬ atLeastAsAssurable model context right left
/--
Strict comparative assurability implies non-strict comparative assurability.
-/
public theorem strictlyMoreAssurable_atLeast
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    {left right : System}
    (strict :
      strictlyMoreAssurable model context left right) :
    atLeastAsAssurable model context left right := by
  exact strict.1
/--
Assurability equivalence is exactly mutual comparative dominance.
Systems with equal capability profiles therefore form the equivalence
classes induced by the comparative assurability preorder.
-/
public theorem assurabilityEquivalent_iff_mutual_dominance
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    (left right : System) :
    assurabilityEquivalent model context left right ↔
      atLeastAsAssurable model context left right ∧
      atLeastAsAssurable model context right left := by
  constructor
  · intro equivalent
    constructor
    · change
        structuralAssurability model right context ⊆
          structuralAssurability model left context
      rw [equivalent]
    · change
        structuralAssurability model left context ⊆
          structuralAssurability model right context
      rw [equivalent]
  · rintro ⟨leftGeRight, rightGeLeft⟩
    change
      structuralAssurability model left context =
        structuralAssurability model right context
    exact Set.Subset.antisymm rightGeLeft leftGeRight
/--
Strict comparative assurability excludes assurability equivalence.
-/
public theorem strictlyMoreAssurable_not_equivalent
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
    (context :
      ComparativeContext
        World
        Evaluator
        Knowledge
        Access
        Trust
        Cooperation
        Budget)
    {left right : System}
    (strict :
      strictlyMoreAssurable model context left right) :
    ¬ assurabilityEquivalent model context left right := by
  intro equivalent
  have bothDirections :=
    (assurabilityEquivalent_iff_mutual_dominance
      model
      context
      left
      right).mp equivalent
  exact strict.2 bothDirections.2
end SE.StructuralAssurability
