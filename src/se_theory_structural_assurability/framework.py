"""Adversarial indistinguishability experiment framework.

A `Channel` declares the world fields it may read and is IMPLEMENTED as a
pure function of ONLY those fields (the world is projected down to the
declared fields before the function is called). This is what "realizable
under stated access restrictions" means here: a channel is structurally
incapable of reading any field it did not declare, and in particular
cannot read the claim's own value, because the claim function is never
passed to a channel or callable from inside one.

`resolved(worlds, channels, claim)` mirrors `claimResolvedBy`: worlds are
grouped by their full observation tuple (all declared channels together),
and the claim must agree within every group.

`witnesses(...)` returns, for each ambiguous observation tuple, one pair of
worlds with that observation and different claim values.
"""

from collections import defaultdict
from itertools import product


class Channel:
    """A channel declares which world fields it reads and implements a function over them."""

    def __init__(self, name, reads, fn):
        """Initialize a channel with a name, the fields it reads, and the function implementing it."""
        self.name = name
        self.reads = tuple(reads)
        self.fn = fn

    def observe(self, world):
        """Return the observation of this channel for the given world."""
        args = tuple(getattr(world, f) for f in self.reads)
        return self.fn(*args)

    def __repr__(self):
        """Return a string representation of the channel, showing its name and read fields."""
        return f"Channel({self.name}, reads={self.reads})"


def _obs_tuple(world, channels):
    return tuple(ch.observe(world) for ch in channels)


def resolved(worlds, channels, claim):
    """True iff every group of worlds sharing an observation tuple agrees on claim."""
    groups = defaultdict(set)
    for w in worlds:
        groups[_obs_tuple(w, channels)].add(claim(w))
    return all(len(v) == 1 for v in groups.values())


def witnesses(worlds, channels, claim):
    """List of (observation_tuple, world_with_claim_true, world_with_claim_false)."""
    groups = defaultdict(list)
    for w in worlds:
        groups[_obs_tuple(w, channels)].append(w)
    out = []
    for obs, ws in groups.items():
        vals = {claim(w) for w in ws}
        if len(vals) > 1:
            a = next(w for w in ws if claim(w))
            b = next(w for w in ws if not claim(w))
            out.append((obs, a, b))
    return out


def sound_partial_verdict(worlds, channels, claim):
    """Compute the coverage of a sound, possibly abstaining reading rule.

    Worlds are grouped by their combined observations. A group is decided
    only when every world in that group agrees on the claim; otherwise,
    the reading rule abstains.

    Returns (coverage_fraction, is_sound, set_of_decided_worlds).

    coverage_fraction is the fraction of enumerated admissible worlds
    belonging to decided groups. Each world is counted equally.

    is_sound is True by construction. No verdict is returned for
    ambiguous observations.

    An empty world set has coverage 1.0 by convention.
    """
    groups = defaultdict(set)
    decided_worlds = defaultdict(list)
    for w in worlds:
        obs = _obs_tuple(w, channels)
        groups[obs].add(claim(w))
        decided_worlds[obs].append(w)
    decided = set()
    for obs, vals in groups.items():
        if len(vals) == 1:
            decided.update(decided_worlds[obs])
    coverage = len(decided) / len(worlds) if worlds else 1.0
    return coverage, True, decided


def enumerate_worlds(world_cls, field_domains, admissible=lambda w: True):
    """field_domains: dict field_name -> iterable of values, in dataclass field order."""
    names = list(field_domains.keys())
    out = []
    for combo in product(*field_domains.values()):
        w = world_cls(**dict(zip(names, combo)))
        if admissible(w):
            out.append(w)
    return out
