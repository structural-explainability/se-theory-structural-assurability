/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import MathlibMini.Set

namespace SE.StructuralAssurability

universe u

/--
A collection of evidence items.

The evidence carrier is intentionally abstract. Evidence may include system
telemetry, infrastructure records, independent observations, physical
measurements, human records, provenance, preserved state, or other artifacts.

Whether evidence is obtainable or material to a claim is defined in later
layers.
-/
public abbrev EvidenceSet (Evidence : Type u) := MathlibMini.Set Evidence

end SE.StructuralAssurability
