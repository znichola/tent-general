# Tent General

It's game with real time tactical combat, you send out your units as a general and attempt to defeat the enemy. Scouts are used to gain vision and relay the position of troops, but there is a time delay, as the general you are presented with a view of the battlefiled that always slightly out of date.

## Stages & basic game loop

- [ ] An overworld node map (slay the spire)
- [ ] Tactical combat
    - [ ] Scout / Unit placment phase
    - [ ] Combat phase

## Scout predicitions

The scout can relay information about the state of the board as it saw it. This can be used by the player to make predicitions about what the correct action is to take.

The scout can also give predicitions, (based on observed data and predetermined heuristicts) which present a few possible scenarios and the probabilities associated. The interesting idea here is to have something like wave collaps where are some point the true state is discovered and everything becomes clear, the tiney single man unit, against all odds, whiped out the larger force, for instance.a

The soute can be interrogated about what they have seen, numbers of units, and how certain they are. This can use used by the player to try corrborate information and get a clearer picture, or not.

