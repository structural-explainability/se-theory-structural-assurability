/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
namespace SE.StructuralAssurability
universe uSystem uCondition uIntervention
/--
A `ControllabilityModel` records which assurance-relevant conditions can be
established and which interventions can be performed for a system.
Conditions and interventions are represented separately because establishing
an evaluation condition need not be identical to intervening on the system.
-/
public structure ControllabilityModel
    (System : Type uSystem)
    (Condition : Type uCondition)
    (Intervention : Type uIntervention) where
  /-- Whether the system can establish the condition. -/
  establishable : System → Condition → Prop
  /-- Whether the intervention can be performed. -/
  performable : System → Intervention → Prop
namespace ControllabilityModel
/--
The conditions that can be established for a system.
-/
public abbrev conditionProfile
    {System : Type uSystem}
    {Condition : Type uCondition}
    {Intervention : Type uIntervention}
    (model : ControllabilityModel System Condition Intervention)
    (system : System) :
    DimensionProfile Condition :=
  { condition | model.establishable system condition }
/--
The interventions that can be performed for a system.
-/
public abbrev interventionProfile
    {System : Type uSystem}
    {Condition : Type uCondition}
    {Intervention : Type uIntervention}
    (model : ControllabilityModel System Condition Intervention)
    (system : System) :
    DimensionProfile Intervention :=
  { intervention | model.performable system intervention }
end ControllabilityModel
end SE.StructuralAssurability
