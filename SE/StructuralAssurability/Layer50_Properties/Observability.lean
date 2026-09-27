/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uObservable
/--
An `ObservabilityModel` records which states, events, behaviors, effects, or
other claim-relevant features can be observed from a system.
The observable carrier is deliberately abstract so that a particular model
may represent internal state, external effects, events, traces, or other
observable features.
-/
public structure ObservabilityModel
    (System : Type uSystem)
    (Observable : Type uObservable) where
  /-- Whether the system exposes the observable feature. -/
  observable : System → Observable → Prop
namespace ObservabilityModel
/--
The observability profile of a system.
This represents the extent of observability extensionally as the set of
features that can be observed rather than as a numerical score.
-/
public abbrev profile
    {System : Type uSystem}
    {Observable : Type uObservable}
    (model : ObservabilityModel System Observable)
    (system : System) :
    DimensionProfile Observable :=
  { feature | model.observable system feature }
end ObservabilityModel
end SE.StructuralAssurability
