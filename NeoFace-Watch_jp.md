# NeoFace Watch
* [評価環境](#評価環境)
* [事前準備](#事前準備)
* [CLUSTERPRO のインストール](#CLUSTERPRO-のインストール)
* [クラスタの作成](#クラスタの作成)
* [NeoFace Watch (Single/Primary Server) のインストール](#NeoFace-Watch-(Single/Primary-Server)-のインストール)
* [NeoFace Watch (Secondary Server) のインストール](#NeoFace-Watch-(Secondary-Server)-のインストール)
* [リソースおよびモニタリソースの追加](#リソースおよびモニタリソースの追加)
* [クラスタの動作確認](#クラスタの動作確認)

## 評価環境
```
    +------------------------------+
 +--| Node #1                      |
 |  | - Windows Server 2016        |
 |  | - NeoFace Watch              |
 |  |   NeoFace Host Service       |
 |  |   NeoFace System Service     |
 |  | - SQL Server 2014            |
 |  | - CLUSTERPRO X 4.0           |
 |  +------------------------------+
 |
 |  +------------------------------+
 +--| Node #2                      |
 |  | - Windows Server 2016        |
 |  | - NeoFace Watch              |
 |  |   NeoFace Host Service       |
 |  |   NeoFace System Service     |
 |  | - SQL Server 2014            |
 |  | - CLUSTERPRO X 4.0           |
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
- 英語環境にて、上記組み合わせを評価しました。

## 事前準備
- 本手順書内の手順は **Administrator** アカウントで実行してください。
- Microsoft の Web ページから PsExec.exe をダウンロードしてください。
- [スクリプトファイル](https://github.com/EXPRESSCLUSTER/NeoFace/tree/master/script/NeoFace-Watch) をダウンロードしてください。また、スクリプトファイル内の ServerList.txt を編集し、NeoFace Processing Service を起動するサーバを追加してください。

## CLUSTERPRO のインストール
1. サーバ nfw01, nfw02 に CLUSTERPRO をインストールしてください。インストール手順は、CLUSTERPRO の **インストール & 設定ガイド** を参照してください。
1. CLUSTERPRO のライセンスを登録してください。
1. [事前準備](#事前準備)でダウンロードした PsExec.exe およびスクリプトファイルを、CLUSTERPRO の bin ディレクトリ (e.g. C:\Program Files\CLUSTERPRO\bin) に保存してください。
1. nfw01, nfw02 を再起動してください。

## クラスタの作成
1. Web ブラウザを起動し、以下の URL にアクセスしてください。Cluster WebUI が起動します。
   ```
   http://<nfw01 の IP アドレス>:29003
   ```
1. **WebManager** をクリックし、**設定モード**に切り替えてください。
1. サーバ nfw02 を追加してください。
1. フェイルオーバグループを追加してください。
1. 以下のリソースを追加してください。
   1. フローティング IP (fip)
   1. ミラーディスク (md)
1. 構成情報をクラスタに反映してください。
1. **操作モード** に切り替え、クラスタを起動してください。
1．クラスタ起動後、ミラーディスクのフルコピーが完了するまで待ってください。

## NeoFace Watch (Single/Primary Server) のインストール 
1. サーバ nfw03 に LM-X License Manager をインストールしてください。
1. NeoFace Watch のインストーラを **nfw01** で実行してください。
1. **Advanced Setup** を選択し、Next をクリックしてください。
1. **Single/Primary Server** を選択し、Next をクリックしてください。
1. **Dashboard** と **Camera Capture** を選択し、Next をクリックしてください。
1. **IP Address** 欄に、**フローティング IP アドレス** を入力してください。**Folder** 欄に、ミラーディスク上のパス (e.g. M:\Program Files\NEC\NeoFace\Watch\ImageLibrary) を設定してください。LM-X License Manager のポート番号、IP アドレスを設定し、Next をクリックしてください。
1. **SQL Server/Instance** にサーバ名とインスタンス名 (e.g. NFW01/NEOFACE) を入力してください。**Username** に **WatchSA** を入力し、Next をクリックしてください。
1. HTTP Port (既定値: 80) を入力し、Next をクリックしてください。
1. インストール完了後、インストーラを終了してください。
1. 以下のサービスが起動していることを確認してください。起動している場合は停止してください。
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - SQL Server (NEOFACE)
   - World Wide Web Publishing Service
1. エクスプローラを起動し、ミラーディスクのパス (e.g. M:\) に移動してください. 
1. ディレクトリに名を **M:\Program Files_01** に変更してください。
1. エクスプローラの画面を閉じてください。
1. フェイルオーバグループを、nfw01 から nfw02 に移動してください。
   ```bat
   C:\> clpgrp -m failover
   ```
1. NeoFace Watch のインストーラを **nfw02** で実行してください。
1. 上記と同様の手順を、サーバ **nfw02** で実施してください。
1. フェイルオーバグループを、nfw02 から nfw01 へ移動してください。
1. サーバ nfw01 にて、**SQL Server (NEOFACE)** を起動してください。
1. SQL Management Studio を起動し、**sa** アカウントで Database Engine に接続してください。
   1. Security 配下の Logins を右クリックし、**New Login** をクリックしてください。
   1. **Login name** に **nfw01/Administrator** を追加してください。
   1. **Server Role** ページにて、**sysadmin** にチェックを入れ、OK をクリックしてください。
1. サーバ nfw01 にて以下のサービスを起動してください。
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - World Wide Web Publishing Service

## NeoFace Watch (Secondary Server) のインストール
1. NeoFace Watch のインストーラを **nfw04** で実行してください。
1. **Secondary Server** を選択して、Next をクリックしてください。
1. Primary server に **フローティング IP アドレス** を入力してください。サーバ nfw04 で使用するポート番号 (e.g. 9001) および IP アドレスを入力し、Next をクリックしてください。
1. UAC に関するポップアップが表示されるので、**Yes** をクリックし、UAC を無効にしてください。
1. ネットワークカメラの各種パラメータを設定してください。**Apply Current Settings** をクリックし、Next をクリックしてください。
1. インストール完了後、インストーラを終了してください。
1. Web ブラウザを起動し、**フローティング IP アドレス** を入力し、NeoFace Watch の GUI にアクセスできることを確認してください。
1. サーバ **nfw01** にて、以下のサービスを停止してください。
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - SQL Server (NEOFACE)
   - World Wide Web Publishing Service
1. サーバ **nfw04** にて、以下のサービスを停止してください。
   - NeoFace Processing Service

## リソースおよびモニタリソースの追加
1. サーバ nfw01 および nfw02 にて、以下のサービスの Starup Type を **Manual** に変更してください。
   - NeoFace Watch System Service
   - NeoFace Watch Host Service
   - SQL Server (NEOFACE)
   - World Wide Web Publishing Service
1. 上記 4 つのサービスを制御するため、サービスリソースを4つ追加し、Service Name または Service Display Name を設定してください。それぞれのサービスリソースの **Wait time after service started** および **Wait time after service stopped** (Detai tab > Tuning) に 30 sec を設定してださい。
1. アプリケーションリソースを追加し、以下のパラメータを設定してください。
   - Resident Type: Non-Resident
   - Start Path: StartNFWPS.bat
   - Stop Path: StopNFWPS.bat
   - Exec User (Start): Administrator account and password 
   - Exec User (Stop): Administrator account and password 
1. 各リソースの依存関係 (Depth) を以下のように設定してください。
   |Depth|Resource Type|Resource Name|備考|
   |-|-------------|-------------|-------|
   |0|Floting IP   |fip||
   |1|Mirror Disk  |md||
   |2|Service      |service-mssql|SQL Server 制御用|
   |3|Service      |service-iis  |IIS 制御用|
   |4|Service      |service-nfwss|NeoFace System Service 制御用|
   |5|Service      |service-nfwhs|NeoFace Host Service 制御用|
   |6|Application  |appli-nfwps  |サーバ nfw04 の NeoFace Processing Service 制御用|
1. 構成情報をクラスタに反映してください。

## クラスタの動作確認
1. サーバ nfw01 にてフェイルオーバグループを起動してください。以下のサービスが起動していることを確認してください。
   - nfw01
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
1. フェイルオーバグループを停止し、以下のサービスが停止していることを確認してください。
   - nfw01
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
1. サーバ nfw02 にてフェイルオーバグループを起動してください。以下のサービスが起動していることを確認してください。
   - nfw02
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
1. フェイルオーバグループを nfw02 から nfw01 へ移動してください。以下のサービスが起動していることを確認してください。
   - nfw01
     - NeoFace Host Service
     - NeoFace System Service
     - SQL Server (NEOFACE)
     - World Wide Web Publishing Service
   - nfw04
     - NeoFace Processing Service
