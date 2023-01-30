# Check if the Control Panel is currently disabled
$isControlPanelDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"

# If the Control Panel is currently disabled, re-enable it
if ($isControlPanelDisabled.NoControlPanel -eq 1) {
  Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
  Write-Host "Control Panel has been re-enabled."
}
# If the Control Panel is not currently disabled, disable it except for the Ease of Access settings
else {
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Accessibility" -Name "NoControlPanel" -Value 0 -PropertyType DWORD
  Write-Host "Control Panel has been disabled, except for the Ease of Access settings."
}
