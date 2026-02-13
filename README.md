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

# Code formatting

To format the code, we use the `gdscript-formatter` tool found [here](https://github.com/GDQuest/GDScript-formatter/releases).\
Then, you can run it like this to format all `.gd` files in the project:
```bash
gdscript-formatter $(find . -name "*.gd")
```

To add the formatter as a precommit hook.

```bash
# Rename the file so git uses it
mv .git/hooks/pre-commit.sample .git/hooks/pre-commit

vim .git/hooks/pre-commit

# Append this to the file, but before the exec call at the end else it's not run!
echo Running formatter ...
gdscript-formatter --safe $(find . -name "*.gd")
```

## TODO

- [ ] teams
- [ ] select unit and give orders to move
- [ ] unit behavior logic / structure
- [ ] rename or figureout the unit vs grop
    
    this decides what should be done
    - unit_order : attack target, stand ground, skermish, move to location, mass route, etc
    - unit_ai : internal state of the unit, we are moving to xy pos
    - unit_capabilities : vision range, target tracking, movement, etc

    each unit individually decides how it will exeute this order, or not
    - unit_behavior : cowardly (this unit will easily run away), brave (this unit will charge first), etc
    - unit_ai : internal state of the unit
    - unit_capabilities : move to xypos and avoid obstacles and other units

- [ ] spawn units
