"""Is "cannot tell whether there were one or two occurrences" the same operation as last turn's position-merge, or genuinely different?

Last turn's channel reported frozenset({content_p2, content_p3}) --
which, whenever the two contents differ, has cardinality 2 and thereby
still reveals COUNT even though it hides ORDER. That was an order-lattice
point, not an occurrence-count ambiguity. This tests the operation the
example actually describes: multiset -> set, forgetting multiplicity
itself, independent of order.

World A: two AT/A occurrences in the middle region (positions 1 and 2).
World B: exactly one AT/A occurrence (position 1 only; position 2
genuinely absent from dom(H) -- not merely hidden, not present).

Claim: "there were two AT/A occurrences in the middle region."
"""

from collections import defaultdict


def resolved(worlds, obs, claim):
    """Check if a claim is resolved in the given worlds and observations."""
    groups = defaultdict(set)
    for w in worlds:
        groups[obs(w)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


# World = dict {position: (operator, actor)}, genuinely partial --
# position 2 simply isn't a key in World B.
world_A = {0: ("BD", "A"), 1: ("AT", "A"), 2: ("AT", "A"), 3: ("VS", "A")}
world_B = {0: ("BD", "A"), 1: ("AT", "A"), 3: ("VS", "A")}  # no key 2 at all
worlds = [world_A, world_B]

claim_count = lambda w: (
    sum(1 for p, e in w.items() if e == ("AT", "A") and p in (1, 2)) == 2
)

# --- Channel 1: full fidelity (reports dom(H) exactly, so count is trivially recoverable) ---
ch_full = lambda w: tuple(sorted(w.items()))


# --- Channel 2: last turn's position-merge, re-run on THIS world pair,
# to show explicitly that it does NOT collapse count when applied honestly. ---
def ch_position_merge(w):
    """Merge the two middle positions into one unordered slot, keeping the ends separate."""
    end0 = w.get(0)
    mid = frozenset(v for p, v in w.items() if p in (1, 2))
    end3 = w.get(3)
    return (end0, mid, end3)


# --- Channel 3: genuine multiplicity-forgetting. Reports the SET of
# distinct values present in the middle region -- not the multiset, not
# even a count -- so "AT/A occurred once" and "AT/A occurred twice" (or
# any number of times >=1) all map to the identical observation.
def ch_multiplicity_blind(w):
    """Report only the set of distinct values present in the middle region, ignoring multiplicity."""
    end0 = w.get(0)
    mid_values_present = frozenset(v for p, v in w.items() if p in (1, 2))
    # deliberately: report only WHICH values occurred, not how many times
    end3 = w.get(3)
    return (end0, mid_values_present, end3)


print(
    "Are ch_position_merge and ch_multiplicity_blind actually the same function?",
    ch_position_merge(world_A) == ch_multiplicity_blind(world_A)
    and ch_position_merge(world_B) == ch_multiplicity_blind(world_B),
)

print("\nWorld A (two AT/A occurrences):", ch_position_merge(world_A))
print("World B (one AT/A occurrence): ", ch_position_merge(world_B))

print("\nfull, resolves:               ", resolved(worlds, ch_full, claim_count))
print(
    "position-merge (last turn's), resolves:",
    resolved(worlds, ch_position_merge, claim_count),
)
