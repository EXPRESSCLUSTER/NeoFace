@echo off
set TIMEOUT=30

for /f %%a in (ServerList.txt) do (
        PsExec.exe %%a -accepteula -nobanner net stop "NeoFace Processing Service"
        for /f "usebackq tokens=*" %%b in (`PsExec.exe %%a -accepteula -nobanner -n %TIMEOUT% sc query "NeoFace Processing Service" ^|find /c /i "1  STOPPED"`) do (
                if "0" == "%%b" clplogcmd -m "Failed to stop NeoFace Processing Service on %%a"
        )
)

