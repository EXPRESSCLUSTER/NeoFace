@echo off
set TIMEOUT=30

for /f %%a in (ServerList.txt) do (
        PsExec.exe %%a -accepteula -nobanner net start "NeoFace Processing Service"
        for /f "usebackq tokens=*" %%b in (`PsExec.exe %%a -accepteula -nobanner -n %TIMEOUT% sc query "NeoFace Processing Service" ^|find /c /i "4  RUNNING"`) do (
                if "0" == "%%b" clplogcmd -m "Failed to start NeoFace Processing Service on %%a"
        )
)

