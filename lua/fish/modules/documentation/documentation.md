# Pinecrest Power Mechanics

## Introduction
### How a Network should work
The standard procedure for how the Power Network should operate is as follows; there must be 1+ Production Node, 1+ Checkpoint Node, and 1 ONLY Resource Node. They must be connected in order for them to work. If they are connected improperly then the system will refuse to work or result in server-wide bugs.

## Generation (Production Node)
- Health: 10,000
- Power Storage: 1,000
- Transfer Rate: 1/s (Power pr Second)
### How do Production Nodes work?
These Nodes spawn in active, which means they are storing power instantly. This allows them to slowly charge up a significant load of energy so if multiple lines are connected, it will take some time before power transferring slows down a lot more (Depending on the amount of connects in the network).

## Transfer (Checkpoint Node)
- Health: 1,500
- Power Storage: 0
- Power Radius: 500 hu (Hammer Units)
### How do Checkpoints work?
When initialised, Checkpoints carry out a number of checks. They check if they have any health, are connected and are switched on. If not, then the Checkpoint spawns in, deactivated.

When interacted with, the player will be able to see the amount of Health it has, and what is its current status (On,Off,Broken).

When it is connected to another Node via a Rope, then it checks if that rope is connected to a Power Node Entity (PNE), if it is, it activates. Once active it tells the next Node to either "Transfer Power" or it tells the Resource Node to begin storing that power.

## Storage (Resource Node)
- Health: 10,000
- Power Storage: 1,000 
- Power Radius: 500 hu (Hammer Units)
### How do Resource Nodes work?
Resource Nodes are initialized in their deactivated mode. Waiting for a connection to a functioning Checkpoint Node before they are activated.

This Node, however, is different in coparison to the other Nodes in the network. The main function of this Node is to store power and to generate a area where Combine Terminals may function within the area of the Node.