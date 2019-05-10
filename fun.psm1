function Start-Fun {
  $reg = Register-ObjectEvent -InputObject ([Microsoft.Win32.SystemEvents]) -EventName "SessionSwitch" -Action {
	[console]::Beep()
    # switch($event.SourceEventArgs.Reason) {
		# 'SessionLock'    { 
			# write-host "lock"
			# start-process "cmd" -argumentList @("/k")
		# }
		# 'SessionUnlock'  {
			# write-host "unlock"
			# start-process "cmd" -argumentList @("/k")
		# }
    # }
  }
  
  start-sleep -seconds 5
  $reg
}

function End-Fun {
    $events = Get-EventSubscriber | Where-Object { $_.SourceObject -eq [Microsoft.Win32.SystemEvents] } 
    $jobs = $events | Select-Object -ExpandProperty Action
    $events | Unregister-Event
    $jobs | Remove-Job
}