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
		write-host "Next Notification in $($env:WAIT_TIME_SECONDS / 60) minute(s)."
		start-sleep -seconds $env:WAIT_TIME_SECONDS
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