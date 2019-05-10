@rem ##############################################################################
@rem Run when Workstation is Locked.
@rem ##############################################################################
if "%DEBUG%" == "" ( set "HIDDEN=-windowstyle hidden")
powershell %HIDDEN% -command "import-module '%~dp0EyeApp.psm1'; runScriptBlock { onLock };" >> %~dp0sessionlog.txt
if not [%errorlevel%]==[0] ( pause )
exit /b %errorlevel%