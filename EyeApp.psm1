$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path

function runScriptBlock($scriptBlock) {
	try {
		&$scriptBlock
		exit 0
	} catch {
		write-error $_
		Write-Error ($_.InvocationInfo | Format-List -Force | Out-String) -ErrorAction Continue
		exit 1
	}
}

function showNotificationRecurring {
	write-host "Starting Recurring Notifications"
	
	while ($true) {
		showNotification
		write-host "Next Notification in $($env:WAIT_TIME_SECONDS / 60) minute(s) at $((get-date).AddSeconds($env:WAIT_TIME_SECONDS))"
		start-sleep -seconds $env:WAIT_TIME_SECONDS
	}
}

function showNotificationRecurring2 {
	showNotification

	$startTime = get-date
	$pollTime = $startTime
	$targetTime = $pollTime.AddSeconds($env:WAIT_TIME_SECONDS)
	$wasLocked = isLocked
	
	write-host "Computer Locked: $wasLocked"
	
	while ($true) {
		# look to see if we are locked
		if (isLocked) {
			if (-not ($wasLocked)) {
				# if this is the first time we noticed we are locked we need to reset the poll timeout
				write-host "Computer locked.  Pausing Timer."
				$wasLocked = $true
			}
		} else {
			if ($wasLocked) {
				write-host "Computer unlocked.  Resetting Timer."
				$wasLocked = $false
				$pollTime = get-date
				$targetTime = $pollTime.AddSeconds($env:WAIT_TIME_SECONDS)
				write-host "Next Notification after $($env:WAIT_TIME_SECONDS / 60) minute(s) at $targetTime"
			}
			
			# we are unlocked, so keep counting
			write-host "not locked...polling again after $env:POLL_INTERVAL_SECONDS"
			$pollTime = $pollTime.AddSeconds($env:POLL_INTERVAL_SECONDS)
		}
		
		# now see if we should display the notification
		write-host "poll time: $pollTime"
		write-host "target time: $targetTime"
		if ($pollTime -gt $targetTime) {
			showNotification
			
			# now reset the poller
			$startTime = get-date
			$pollTime = $startTime
			$targetTime = $pollTime.AddSeconds($env:WAIT_TIME_SECONDS)
		} else {
			# wait for the next poll
			start-sleep -seconds $env:POLL_INTERVAL_SECONDS
		}
	}
}

function showNotification {
	write-host "Showing notification at $(get-date)"
	start-process "powershell" -argumentList @("-command", "import-module '$scriptDir\EyeApp.psm1'; runScriptBlock { printNotification }") -wait
	write-host "Notification closed at $(get-date)"
}

function printNotification {
	$host.ui.RawUI.WindowTitle = "20/20/20 EyeApp"
	$Host.UI.RawUI.BackgroundColor = "black"
	$hashColor = "darkgreen"
	$messageColor = "yellow"
	clear-host
	write-host $((get-date).toString())
	write-host
	write-host "#######################################################" -foregroundcolor $hashColor
	write-host "####################" -nonewline -foregroundcolor $hashColor
	write-host "              " -nonewline
	write-host "#####################" -foregroundcolor $hashColor
	write-host "####################" -nonewline -foregroundcolor $hashColor
	write-host " 20 / 20 / 20 " -nonewline
	write-host "#####################" -foregroundcolor $hashColor
	write-host "####################" -nonewline -foregroundcolor $hashColor
	write-host "              " -nonewline
	write-host "#####################" -foregroundcolor $hashColor
	write-host "#######################################################" -foregroundcolor $hashColor
	write-host
	pause
	timeout /t $env:NOTIFY_WAIT_TIME_SECONDS
}

function isLocked {
	return (test-path "$scriptDir\LOCK")
}

function onLock {
	write-host "Computer locked at $(get-date)"
	set-content -path "$scriptDir\LOCK" -value "LOCKED at $(get-date)"
}

function onUnlock {
	write-host "Computer unlocked at $(get-date)"
	remove-item "$scriptDir\LOCK"
}