# NeoFace Watch
## Index
- [Evaluation Environment](#Evaluation-Environment)
- [Prerequisite](#Prerequisite)
- [Install EXPRESSCLUSTER](#Install-EXPRESSCLUSTER)
- [Create Base Cluster](#Create-Base-Cluster)
- [Install NeoFace Watch (Single/Primary Server)](#install-neoface-watch-singleprimary-server)
- [Install NeoFace Watch (Secondary Server)](install-neoface-watch-secondary-server)
- [Add Resources to Control NeoFace](#Add-Resources-to-Control-NeoFace)

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

## Prerequisite
- Do the following installation steps with **Administrator** accout.
- Download PsExec.exe from Microsoft web site.
- Download the [script files](https://github.com/EXPRESSCLUSTER/NeoFace/tree/master/script/NeoFace-Watch) and modify ServerList.txt to add a server runs NeoFace Processing Service.

## Install EXPRESSCLUSTER
1. Install EXPRESSCLUSTER on both nfw01 and nfw02 following **Installation and Configuration Guide**.
1. Register the licenses.
1. Save PsExec.exe and the script files on EXPRESSCLUSTER bin directory (e.g. C:\Program Files\EXPRESSCLUSTER\bin).
1. Restart both nodes.

## Create Base Cluster
1. Launch a web browser and enter the following URL. Cluster WebUI starts up.
   ```
   http://<IP address of nfw01>:29003.
   ```
1. Click **WebManager** and switch to **Config Mode**.
1. Add nfw02.
1. Add a failover group.
1. Add following group resources.
   - Floating IP (fip)
   - Mirror Disk (md)
1. Apply the cluster configuration that you have created.
1. Switch to **Operation Mode** and start the cluster.
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
   - World Wide Web Publishing Service
1. Start Windows Explorer and move to the mirror disk drive (e.g. M:\). 
1. Rename the directory M:\Program Files to **M:\Program Files_01**.
1. Close Windows Explorer window.
1. Move the failover group from nfw01 to nfw02.
   ```bat
   C:\> clpgrp -m failover
   ```
1. Run NeoFace Watch installer on **nfw02**.
1. Do the same installation steps on **nfw02**.
1. Move back the failover group from **nfw02** to **nfw01**.
1. Start **SQL Server (NEOFACE)** service.
1. Start SQL Management Studio and connect to Database Engine with **sa** account.
   1. Click Security, right-click Logins and click **New Login**.
   1. Set **nfw01/Administrator** to **Login name** on General page.
   1. Select **Server Role** page, check **sysadmin** and click OK.
1. Start the following services.
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - World Wide Web Publishing Service

## Install NeoFace Watch (Secondary Server)
1. Run NeoFace Watch installer on **nfw04**.
1. Select **Secondary Server** and click Next.
1. Set **floating IP address** for primary server. Set port number (e.g. 9001) and the IP address of nfw04. Click Next.
1. Click **Yes** to disable UAC.
1. Set the parameters of the network camera and click **Apply Current Settings**. click Next.
1. Finish the installer.
1. Start the web browser and enter **floating IP address** to access 
1. Stop the following services on **nfw01**.
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - SQL Server (NEOFACE)
   - World Wide Web Publishing Service
1. Stop the following service on **nfw04**.
   - NeoFace Processing Service

## Add Resources to Control NeoFace
1. Change Starup Type from Auto to **Manual** for the following services.
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - SQL Server (NEOFACE)
   - World Wide Web Publishing Service
1. Add 4 service resources and set the above service name or service display name. And set 30 sec for **Wait time after service started** and **Wait time after service stopped** (Detai tab > Tuning).
1. Add an application resource and set the following parameters on Detail tab.
   - Resident Type: Non-Resident
   - Start Path: StartNFWPS.bat
   - Stop Path: StopNFWPS.bat
   - Exec User (Start): Administrator account and password 
   - Exec User (Stop): Administrator account and password 
1. Change dependencies (Depth) of resources as below.
   |Depth|Resource Type|Resource Name|Remarks|
   |-|-------------|-------------|-------|
   |0|Floting IP   |fip||
   |1|Mirror Disk  |md||
   |2|Service      |service-mssql|Control SQL Server|
   |3|Service      |service-iis|Control IIS|
   |4|Service      |service-nfwss|Control NeoFace System Service|
   |5|Service      |service-nfwhs|Control NeoFace Host Service|
   |6|Application  |appli-nfwps|Restart NeoFace Processing Service on nfw04|
1. Apply the cluster configuration.

## Verify Functionality of EXPRESSCLUSTER
1. Start the failover group on **nfw01** and check if the following services are running.
   - nfw01
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
1. Stop the failover group and check if the following services are stopped.
   - nfw01
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
1. Start the failover group on **nfw02** and check if the following services are running.
   - nfw02
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
1. Move the failover group from **nfw02** to **nfw01** and check if the following services are running.
   - nfw01
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
