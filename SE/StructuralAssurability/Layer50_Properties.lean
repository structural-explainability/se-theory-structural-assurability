/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all
public import SE.StructuralAssurability.Layer50_Properties.CandidateDimension
public import SE.StructuralAssurability.Layer50_Properties.Observability
public import SE.StructuralAssurability.Layer50_Properties.Controllability
public import SE.StructuralAssurability.Layer50_Properties.Traceability
public import SE.StructuralAssurability.Layer50_Properties.Reconstructability
public import SE.StructuralAssurability.Layer50_Properties.Independence
public import SE.StructuralAssurability.Layer50_Properties.Integrity
public import SE.StructuralAssurability.Layer50_Properties.EvidenceCoverage
/-!
# Layer 50: Candidate Structural Properties
Formal models for the current candidate structural dimensions of
Structural Assurability:
- observability;
- controllability;
- traceability;
- reconstructability;
- independence;
- integrity; and
- evidence coverage.
The candidate set is deliberately provisional.
This layer does not assert that:
- the seven dimensions are complete;
- the dimensions are mutually independent;
- every dimension is necessary for every assurance claim;
- increasing a dimension necessarily increases assurability; or
- the dimensions are jointly sufficient for assurance.
The models represent structural distinctions that may affect the evidence
made available by a system and its evidence-producing environment.
Layer 60 determines whether a candidate dimension contributes to
Structural Assurability through separating constructions.
Derived properties such as reproducibility, auditability, monitorability,
testability, and diagnosability remain evidentiary capabilities rather than
primitive structural dimensions.
-/
