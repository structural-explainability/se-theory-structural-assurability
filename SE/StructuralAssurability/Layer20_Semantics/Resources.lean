/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.StructuralAssurability.Layer10_Foundation.Evidence

namespace SE.StructuralAssurability

universe uSystem uEvidence uBudget

/--
A `ResourceModel` specifies whether an evidence item is feasible to obtain
from or about a system under a particular resource budget.

The budget carrier is intentionally abstract. It may represent constraints
in time, computation, money, queries, storage, personnel, expertise, or other
resources relevant to an assurance activity.

This model represents the `B` contribution to practical obtainability.
-/
public structure ResourceModel
    (System : Type uSystem)
    (Evidence : Type uEvidence)
    (Budget : Type uBudget) where
  /-- Whether the evidence can be obtained within the resource budget. -/
  feasible : System → Budget → Evidence → Prop

namespace ResourceModel

/--
The evidence feasible for a system under a specified resource budget.
-/
public abbrev feasibleEvidence
    {System : Type uSystem}
    {Evidence : Type uEvidence}
    {Budget : Type uBudget}
    (model : ResourceModel System Evidence Budget)
    (system : System)
    (budget : Budget) :
    EvidenceSet Evidence :=
  { evidence | model.feasible system budget evidence }

end ResourceModel

end SE.StructuralAssurability
