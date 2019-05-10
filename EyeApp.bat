@rem ##############################################################################
@rem Show a notification every 20 minutes.
@rem (20 minutes * 60 seconds / minute = 1200 seconds)
@rem ##############################################################################
if "%WAIT_TIME_SECONDS%" == "" (set WAIT_TIME_SECONDS=1200)
if "%NOTNOTIFY_WAIT_TIME_SECONDS%" == "" (set NOTIFY_WAIT_TIME_SECONDS=20)
if "%POLL_INTERVAL_SECONDS%" == "" (set POLL_INTERVAL_SECONDS=60)
if "%DEBUG%" == "" ( set "HIDDEN=-windowstyle hidden")
echo > %~dp0log.txt
echo > %~dp0sessionlog.txt
powershell %HIDDEN% -command "import-module '%~dp0EyeApp.psm1'; runScriptBlock { showNotificationRecurring };" >> %~dp0log.txt
if not [%errorlevel%]==[0] ( pause )
exit /b %errorlevel%