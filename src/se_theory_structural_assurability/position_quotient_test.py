"""Is quotienting Position itself (merging two true positions into one observed, unordered slot.

p1 < {p2,p3} < p4) a genuinely distinct
mechanism from the three already checked, or is it secretly the same
as full order-reduct applied locally?

The test: find a claim that SURVIVES position-merging but does NOT
survive full order-reduct. If one exists, position-quotient sits
strictly between full fidelity and total order-loss -- a real
intermediate point, not a relabeling of what's already been checked.

Claim: does the P1-labeled event occur before the P4-labeled event?
This claim depends ONLY on the relative order of the two END positions
-- nothing about the two MIDDLE positions' mutual order. Position-
merging the middle two should leave it resolvable; forgetting all
order should not.
"""

from collections import defaultdict


def resolved(worlds, obs, claim):
    """Check if a claim is resolved in the given worlds and observations."""
    groups = defaultdict(set)
    for w in worlds:
        groups[obs(w)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


# Fixed content per LABEL; only the label's assigned slot varies.
CONTENT = {
    "P1": ("BD", "A"),
    "Pmid_a": ("AT", "A"),
    "Pmid_b": ("CL", "B"),
    "P4": ("VS", "A"),
}

# Two true histories: P1 first vs P4 first. Pmid_a, Pmid_b always
# occupy the two middle slots (order between THEM also varies, to make
# sure the test isn't accidentally fixing more than it should).
worlds = []
for end_order in (("P1", "P4"), ("P4", "P1")):
    for mid_order in (("Pmid_a", "Pmid_b"), ("Pmid_b", "Pmid_a")):
        labels_in_slot_order = (end_order[0],) + mid_order + (end_order[1],)
        worlds.append(labels_in_slot_order)

print(f"{len(worlds)} worlds:")
for w in worlds:
    print(" ", w)


def slot_of(world, label):
    """Return the slot index of the given label in the world."""
    return world.index(label)


claim_ends_order = lambda w: slot_of(w, "P1") < slot_of(w, "P4")

# --- Channels ---


def ch_full(world):
    """Full fidelity: each slot individually identified, content fully visible."""
    return tuple((slot, CONTENT[label]) for slot, label in enumerate(world))


def ch_position_merge(world):
    """Slots 1,2 (the middle two) collapse into one unordered slot.

    Slot 0 and slot 3 (the ends) remain individually identified, and
    their position relative to the merged block is preserved.
    """
    end0 = CONTENT[world[0]]
    merged = frozenset({CONTENT[world[1]], CONTENT[world[2]]})
    end3 = CONTENT[world[3]]
    return (("slot0", end0), ("merged", merged), ("slot3", end3))


def ch_full_order_reduct(world):
    """Everything collapses into one unordered multiset.

    No slot identity survives at all, not even for the end positions.
    """
    return frozenset(CONTENT[label] for label in world)


print("\nDoes each channel resolve 'P1 occurs before P4'?\n")
for name, ch in [
    ("full", ch_full),
    ("position-merge (middle two)", ch_position_merge),
    ("full order-reduct", ch_full_order_reduct),
]:
    r = resolved(worlds, ch, claim_ends_order)
    print(f"  {name:32s} resolves: {r}")

w = None
groups = defaultdict(list)
for world in worlds:
    groups[ch_full_order_reduct(world)].append(world)
for ws in groups.values():
    vals = {claim_ends_order(w) for w in ws}
    if len(vals) > 1:
        a = next(w for w in ws if claim_ends_order(w))
        b = next(w for w in ws if not claim_ends_order(w))
        print(
            f"\n  order-reduct witness: {a} (P1 first) vs {b} (P4 first) -- identical multiset, claim disagrees"
        )
        break
