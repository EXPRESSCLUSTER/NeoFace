# NeoFace Watch
* [評価環境](#評価環境)
* [事前準備](#事前準備)
* [CLUSTERPRO のインストール](#CLUSTERPRO-のインストール)
* [クラスタの作成](#クラスタの作成)
* [NeoFace Watch (Single/Primary Server) のインストール](#NeoFace-Watch-(Single/Primary-Server)-のインストール)
* [NeoFace Watch (Secondary Server) のインストール](#NeoFace-Watch-(Secondary-Server)-のインストール)
* [リソースおよびモニタリソースの追加](#リソースおよびモニタリソースの追加)


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

## 事前準備
- 本手順書内の手順は **Administrator** アカウントで実行してください。
- Microsoft の Web ページから PsExec.exe をダウンロードしてください。
- [スクリプトファイル](https://github.com/EXPRESSCLUSTER/NeoFace/tree/master/script/NeoFace-Watch) をダウンロードしてください。また、スクリプトファイル内の ServerList.txt を編集し、NeoFace Processing Service を起動するサーバを追加してください。

## CLUSTERPRO のインストール
1. サーバ nfw01, nfw02 に CLUSTERPRO をインストールしてください。インストール手順は、CLUSTERPRO の **インストール & 設定ガイド** を参照してください。
1. CLUSTERPRO のライセンスを登録してください。
1. [事前準備](#事前準備)でダウンロードした PsExec.exe およびスクリプトファイルを、CLUSTERPRO の bin ディレクトリ (例: C:\Program Files\CLUSTERPRO\bin) に保存してください。
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
1. NeoFace Watch のインストーラを nfw01 で実行してください。
1. 

## NeoFace Watch (Secondary Server) のインストール

## リソースおよびモニタリソースの追加
