/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uEvidence uTraceTarget
/--
A `TraceabilityModel` records which origins, transformation-history elements,
system events, or other trace targets can be associated with a piece of
evidence.
The trace-target carrier is abstract because different assurance problems
require different forms of attribution and provenance.
-/
public structure TraceabilityModel
    (System : Type uSystem)
    (Evidence : Type uEvidence)
    (TraceTarget : Type uTraceTarget) where
  /-- Whether the evidence can be traced to the target. -/
  traceable : System → Evidence → TraceTarget → Prop
namespace TraceabilityModel
/--
The trace targets that can be associated with a specified evidence item.
-/
public abbrev targets
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {TraceTarget : Type uTraceTarget}
    (model : TraceabilityModel System Evidence TraceTarget)
    (system : System)
    (evidence : Evidence) :
    DimensionProfile TraceTarget :=
  { target | model.traceable system evidence target }
end TraceabilityModel
end SE.StructuralAssurability
