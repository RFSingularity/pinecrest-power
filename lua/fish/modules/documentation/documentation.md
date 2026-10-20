# Pinecrest Power Mechanics

## Introduction
### How a Network should work
The standard procedure for how the Power Network should operate is as follows; there must be 1+ Production Node, 1+ Checkpoint Node, and 1 ONLY Resource Node. They must be connected in order for them to work. If they are connected improperly then the system will refuse to work or result in server-wide bugs.

## Generation (Production Node)
- Health, Transfer Rate, Storage
- How does it work?

## Transfer (Checkpoint Node)
- Health, Transfer Rate, Storage
### How do Checkpoints work?
When initialised, Checkpoints carry out a number of checks. They check if they have any health, are connected and are switched on. If not, then the Checkpoint spawns in, deactivated.

When interacted with, the player will be able to see the amount of Health it has, and what is its current status (On,Off,Broken).

When it is connected to another Node via a Rope, then it checks if that rope is connected to a Power Node Entity (PNE), if it is, it activates. Once active it tells the next Node to either "Transfer Power" or it tells the Resource Node to begin storing that power.

## Storage (Resource Node)
- Health, Transfer Rate, Storage
- How does it work?