# Status system

The status system is responsible for **applying**, **rechecking** and handling **STATUS** effects

These effects can range from physical, such as **_burning_**, **_poisoning_**, but also many more.

## Status
A status is composed of:

* **Status type** - this defines the behavior on applying a status, from **STACKING**, **RESETTING** or **MERGING** them
* **Ticks to apply** - how many Status Controller ticks before it applies the status's effects
* **Ticks to recheck** - how many Status Controller ticks before it checks if the status should remain active
* **Effects** - a list of **Status Effects**
* **Recheck handler** - called when the Status Controller rechecks status validity 

It also holds other info such as
* **Active flag** - whether the status is active
* **Ticks** - internal counter for how many ticks this status has been active

## Status Effects
A status effect is a simple script that has an '**apply**' method, as well as a type of Element attached to it

This design decision allows for a status to contains multiple elemental effects, as needed.

## Status Controller
A **Status Controller** is responsible for:
* Holding all the applied statuses to an entity
* Manage them

## Status Source
In order to apply a status, a status source is needed.

One example of a status source is an Area Of Effect(AoE), a simple Area 2D that applies a status on contact.
