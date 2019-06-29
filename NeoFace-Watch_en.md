# NeoFace Watch
## Evaluation Environment
```
    +------------------------------+
 +--| Node #1 - nfw01              |
 |  | - Windows Server 2016        |
 |  | - NeoFace Watch              |
 |  |   NeoFace Host Service       |
 |  |   NeoFace System Service     |
 |  | - SQL Server 2014            |
 |  | - EXPRESSCLUSTER X 4.0       |
 |  +------------------------------+
 |
 |  +------------------------------+
 +--| Node #2 - nfw02              |
 |  | - Windows Server 2016        |
 |  | - NeoFace Watch              |
 |  |   NeoFace Host Service       |
 |  |   NeoFace System Service     |
 |  | - SQL Server 2014            |
 |  | - EXPRESSCLUSTER X 4.0       |
 |  +------------------------------+
 |
 |  +------------------------------+
 +--| Node #3 - nfw03              |
 |  | - Windows Server 2016        |
 |  | - LM-X License Server        |
 |  +------------------------------+
 |
 |  +------------------------------+  +----------------+
 +--| Node #4 - nfw04              |--| Network Camera |
    | - Windows Server 2016        |  +----------------+
    | - NeoFace Watch              |
    |   NeoFace Processing Service |
    +------------------------------+
```
- If you need to add more cameras, you need to add more server to run NeoFace Processing Service.

## Install EXPRESSCLUSTER
1. Install EXPRESSCLUSTER on both nfw01 and nfw02 following **Installation and Configuration Guide**.
1. Register the licenses.
1. Restart both nodes.

## Create Base Cluster
1. Launch a web browser and access http://_nfw01-IP-address_:29003.
1. Click **WebManager** to create a cluster.
1. Add nfw02.
1. Add a failover group.
1. Add following group resources.
   - Floating IP (fip)
   - Mirror Disk (md)
1. Add any monitor resource if you want to setup.
1. Apply the cluster configuration that you have created.
1. Start the cluster.
1. Wait for the initial full copy of the mirror disk to be completed.
1. Check if the failover group is running on **nfw01**. If not, move the failover group from nfw02 to nfw01.

## Install NeoFace Watch (Single/Primary Server)
1. Install LM-X License Manager on nfw03 in advance.
1. Run NeoFace Watch installer on **nfw01**.
1. Select **Advanced Setup** and click Next.
1. Select **Single/Primary Server** and click Next.
1. Check **Dashboard** and **Camera Capture**, then click Next.
1. Set **Floating IP Address** for **IP Address**. Set the mirror disk drive path (e.g. M:\Program Files\NEC\NeoFace\Watch\ImageLibrary) for **Folder**. Set port number and IP Address of LM-X License Manager .
1. Set server name and instance name to **SQL Server/Instance** (e.g. NFW01/NEOFACE). Set **WatchSA** for Username and click Next.
1. Set HTTP Port and click Next.
1. Finish the installer.
1. Check if NeoFace Watch services and SQL Server as below are running. If they are running, stop them.
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - SQL Server (NEOFACE)
1. Start Windows Explorer and move to the mirror disk drive (e.g. M:\). 
1. Rename <FIXME>.
1. Close Windows Explorer window.
1. Move the failover group from nfw01 to nfw02.
   ```bat
   C:\> clpgrp -m failover
   ```
1. Run NeoFace Watch installer on **nfw02**.
1. Do the same installation steps on **nfw02**.
1. Move back the failover group from **nfw02** to **nfw01**.
1. Start SQL Server (NEOFACE) service.
1. Start SQL Management Studio
   1. add
1.  

## Install NeoFace Watch (Secondary Server)
1. 

## Add Resources to Control NeoFace
1. 
1. 

|Depth|Resource Type|Resource Name|Remarks|
|-|-------------|-------------|-------|
|0|service      |service-mssql||
|1|service      |service-mssql||
|2|service      |service-mssql||
|3|script      |service-mssql||