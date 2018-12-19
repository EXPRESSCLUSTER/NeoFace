*UNDER CONSTRUCTION*

# NeoFace Watch
* [Evaluation Environment](#evaluation-environment)

## Evaluation Environment
```
    +------------------------------+
 +--| Node #1                      |
 |  | - Windows Server 2016        |
 |  | - NeoFace Watch              |
 |  |   NeoFace Host Service       |
 |  |   NeoFace System Service     |
 |  | - SQL Server 2014            |
 |  | - EXPRESSCLUSTER X 4.0       |
 |  +------------------------------+
 |
 |  +------------------------------+
 +--| Node #2                      |
 |  | - Windows Server 2016        |
 |  | - NeoFace Watch              |
 |  |   NeoFace Host Service       |
 |  |   NeoFace System Service     |
 |  | - SQL Server 2014            |
 |  | - EXPRESSCLUSTER X 4.0       |
 |  +------------------------------+
 |
 |  +------------------------------+
 +--| Node #3                      |
 |  | - Windows Server 2016        |
 |  | - LM-X License Server        |
 |  +------------------------------+
 |
 |  +------------------------------+
 +--| Node #4                      |
    | - Windows Server 2016        |
    | - NeoFace Watch              |
    |   NeoFace Processing Service |
    +------------------------------+
```

## Install EXPRESSCLUSTER
1. Install EXPRESSCLUSTER on both Node #1 and #2 following **Installation and Configuration Guide**.
1. Register the licenses.
1. Restart both nodes.

## Create Base Cluster
1. Launch any web browser and access http://_node#1-IP-address_:29003.
1. Click **WebManager** to create a cluster.
1. Add node #2.
1. Setup a failover group.
1. Add following group resources.
   1. Floating IP (fip)
   1. Mirror Disk (md)
1. Add any monitor resource if you want to setup.
1. Apply the cluster configuration that you have created.
1. Start a cluster.
1. Wait for the initial full copy of the mirror disk to be completed.

## Install NeoFace Watch


## Add Resources to Control NeoFace
