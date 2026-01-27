# Status system

The status system is responsible for handling **STATUS** effects.

These effects can range from physical, such as **_burning_**, **_poisoning_**, but also many more.

## Status
A status is composed of:

* **Status type** - this defines the behavior on applying a status, such as **STACKING** or **REPLACING** them
* **Ticks to apply** - how many **Status Controller**'s ticks before it applies the status's effects
* **Effects** - a list of **Status Effects**

* **Status lifetime ticks** - how many ticks before a stack is removed.

It also holds other info such as
* **Active flag** - whether the status is active
* **Ticks** - internal counter for how many ticks this status has been active

### Stack
Any given status may hold a number of **Stacks**. A stack holds an individual tick counter, as it is processed individually.

## Status Effects
A status effect is a simple script that has an '**apply**' method, as well as a type of Element attached to it

This design decision allows for a status to contains multiple elemental effects, as needed.

## Status Controller
A **Status Controller** is responsible for:
* Holding all the applied statuses to an entity
* Manage them

It holds a timer that ticks at fixed intervals, and it processes every status, one by one and by status.

Each status has an individual counter, so that its processed individually. 
If the amount defined in **apply ticks** has passed for a stack, the status's effects are applied to the entity.

After the lifetime amount has passed, the stack is then removed. If a status has no stacks, it's marked as inactive
and the status node is marked to not be processed.

## Status Source
In order to apply a status, a status source is needed.

One example of a status source is an Area Of Effect(AoE), a simple Area 2D that applies a status on contact.
