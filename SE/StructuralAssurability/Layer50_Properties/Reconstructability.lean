/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uReconstructionTarget
/--
A `ReconstructabilityModel` records which relevant executions, decision
sequences, system states, or other historical targets can subsequently be
reconstructed from preserved evidence.
The model concerns structural reconstructability and does not by itself
assert that a reconstruction is evidentially valid or sufficient.
-/
public structure ReconstructabilityModel
    (System : Type uSystem)
    (ReconstructionTarget : Type uReconstructionTarget) where
  /-- Whether the reconstruction target can be reconstructed. -/
  reconstructable : System → ReconstructionTarget → Prop
namespace ReconstructabilityModel
/--
The reconstruction targets supported by a system.
-/
public abbrev profile
    {System : Type uSystem}
    {ReconstructionTarget : Type uReconstructionTarget}
    (model : ReconstructabilityModel System ReconstructionTarget)
    (system : System) :
    DimensionProfile ReconstructionTarget :=
  { target | model.reconstructable system target }
end ReconstructabilityModel
end SE.StructuralAssurability
