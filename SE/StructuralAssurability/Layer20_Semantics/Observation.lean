/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer10_Foundation.World
public import SE.StructuralAssurability.Layer10_Foundation.Evidence

namespace SE.StructuralAssurability

universe uWorld uObservation uEvidence

/--
An `ObservationModel` specifies what an evaluator-facing observation reveals
about each possible world.

The observation carrier is intentionally abstract. An observation may be a
single value, a structured record, a trace, or an entire evidence set.

The model does not assert that the observation is valid, sufficient, or
claim-material.
-/
public structure ObservationModel
    (World : Type uWorld)
    (Observation : Type uObservation) where
  /-- Observation produced by a world. -/
  observe : World → Observation

/--
An observation model whose observations are sets of evidence items.
-/
public abbrev EvidenceObservationModel
    (World : Type uWorld)
    (Evidence : Type uEvidence) :=
  ObservationModel World (EvidenceSet Evidence)

end SE.StructuralAssurability
