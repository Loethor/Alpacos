# Weapon design in Alpacos

This document provides an analysis about the scene and/or class structured required for the weapon system in Alpacos.

In order to have a similar system as in [this game](https://worms2d.info/Template:WA_weapons), we need to analyze the different kind of weapons available, what are their characteristics, commonalities, and differences.

## Types of weapons

All the weapons in the game can be grouped in the following types:
- **Launch**: You can aim, hold and release the button. The longer the button is pressed, more initial velocity the proyectile will have (except mortar). These are generally affected by wind.
- **Throw**: Similar to charged shoot, but they are mostly grenades and they are not affected by wind.
- **Melee**: Weapons of contact damage. Triggered by pressing (not holding) the button. Some of them require aim (baseball bat).
- **Shoot**: These weapons are triggered by pressing (not holding) the button. They have hitscan (no projectile, instant damage) and different shoot properties.
- **Utilities**: These are multipurpose tools, not focused in damage. They can either be triggered by pressing (not holding) the button or clicking a position with the mouse.
- **Drop**: Similar to throw, but they are dropped at your feet. Triggered by pressing (not holding) the button. 
- **Air Strikes**: By clicking a position, an airstrike will follow.
- **Special**: for the weapons that fit nowhere.
## Weapons per category

The following table categorizes the weapons based in our weapon types.
|  | **Launch** | **Throw** | **Drop** | **Shoot** | **Air Strike** | **Melee** | **Utility** | **Special** |
|---|---|---|---|---|---|---|---|---|
| Bazooka | x |  |  |  |  |  |  |  |
| Homing Missile | x |  |  |  | x |  |  |  |
| Mortar | x |  |  |  |  |  |  |  |
| Homing Pidgeon |  |  | x |  | x |  |  |  |
| Sheep Launcher | x |  |  |  |  |  |  |  |
| Grenade |  |  |  |  |  |  |  |  |
| Cluster Grenade |  |  |  |  |  |  |  |  |
| Banana Bomb |  | x |  |  |  |  |  |  |
| Battle Axe |  |  |  |  |  | x |  |  |
| Shotgun |  |  |  | x |  |  |  |  |
| Handgun |  |  |  | x |  |  |  |  |
| Uzi |  |  |  | x |  |  |  |  |
| Minigun |  |  |  | x |  |  |  |  |
| Longbow |  |  |  | x |  |  |  |  |
| Fire Punch |  |  |  |  |  | x |  |  |
| Dragon Ball |  |  |  |  |  | x |  |  |
| Kamikaze |  |  |  | x |  |  |  |  |
| Suicide bomber |  |  | x |  |  |  |  |  |
| Prod |  |  |  |  |  | x |  |  |
| Dynamite |  |  | x |  |  |  |  |  |
| Mine |  |  | x |  |  |  |  |  |
| Sheep |  |  | x |  |  |  |  |  |
| Super sheep |  |  | x |  |  |  |  | x |
| Mole bomb |  |  | x |  |  |  |  |  |
| Air Strike |  |  |  |  | x |  |  |  |
| Napalm |  |  |  |  | x |  |  |  |
| Mail Strike |  |  |  |  | x |  |  |  |
| Mine strike |  |  |  |  | x |  |  |  |
| Mole squadron |  |  |  |  | x |  |  |  |
| Blow torch |  |  |  |  |  |  | x |  |
| Pneumatic drill |  |  |  |  |  |  | x |  |
| Girder |  |  |  |  |  |  | x |  |
| Baseball bat |  |  |  |  |  | x |  |  |
| Teleport |  |  |  |  |  |  | x |  |
| Scales of Justice |  |  |  |  |  |  | x |  |
|  Super Banana Bomb  |  | x |  |  |  |  |  |  |
|  Holy Hand Grenade  |  | x |  |  |  |  |  |  |
|  Flame Thrower  |  |  |  | x |  |  |  |  |
|  Petrol Bomb  |  | x |  |  |  |  |  |  |
|  Skunk  |  |  | x |  |  |  |  |  |
|  French Sheep Strike  |  |  |  |  | x |  |  |  |
|  Mad Cows  |  |  | x |  |  |  |  |  |
|  Old Woman |  |  | x |  |  |  |  |  |
|  Skip Go  |  |  |  |  |  |  | x |  |
|  Surrender  |  |  |  |  |  |  | x |  |
|  Select Worm |  |  |  |  |  |  | x |  |

## Commonalities between types

Throw, Launch, and shoot weapons allow you to aim.
Throw and Launch allow you to hold and release to vary the strength.
Shoot, drop, melee, and some utily use a single button press.
Air strikes and utily mainly use click.

Special will be excluded from further analysis.

## Differences between types

Throw and Launch: Launch is affected by wind.
Shoot and Throw/Launch: Shoot has single shot, other have charged

|  | Can aim | Charged shot | Single press | Click | Affected by wind |
|---|---|---|---|---|---|
| Launch | x | x |  |  | x |
| Throw | x | x |  |  |  |
| Drop |  |  |  |  |  |
| Shoot | x |  | x |  |  |
| Air Strike |  |  |  | x |  |
| Melee |  |  | x |  |  |
| Utility  |  |  | x | x |  |

# Class design

Godot doesn't allow multiple inheritance and there is not a simple inheritance path. I choose to use composition.

The minimum amount of rehusable behaviour will be chosen as component.
Some initial proposal:
- Aim component: handles the angle of aiming and the texture rotation. Any projectile will be generated with this angle.
- Wind component: whether this weapon is affected by wind or not.
- ChargedShot component: handles how holding the button modifies the initial velocity of the weapon.
- SinglePress component: handles the shooting behavior.
- Click component: handles the click behavior.

By using this guidelines, a grenade could have an AimComponent and a ChargedShotComponent.