@rem ##############################################################################
@rem Show a notification every 20 minutes.
@rem (20 minutes * 60 seconds / minute = 1200 seconds)
@rem ##############################################################################
set WAIT_TIME_SECONDS=1200
set NOTIFY_WAIT_TIME_SECONDS=20
if "%DEBUG%" == "" ( set "HIDDEN=-windowstyle hidden")
powershell %HIDDEN% -command "import-module '%~dp0EyeApp.psm1'; runScriptBlock { showNotificationRecurring };"
if not [%errorlevel%]==[0] ( pause )
exit /b %errorlevel%