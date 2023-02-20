$taskName = "Task1"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\Scripts\Task1.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -User "SYSTEM" -RunLevel Highest

$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($task -ne $null) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$scriptPath = "C:\Scripts\Task1.ps1"
$networkPath = "\\SERVER\Scripts\Task1.ps1"
if (Test-Path $networkPath) {
    $networkScript = Get-Content $networkPath
    $localScript = Get-Content $scriptPath
    if ($networkScript -ne $localScript) {
        Set-Content $scriptPath $networkScript
    }
}
