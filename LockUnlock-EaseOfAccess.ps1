# Function to check the state of the Control Panel and Windows Settings
Function Check-SettingsState {
  $isControlPanelDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
  $isWindowsSettingsDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings"

  # Return the state of the Control Panel and Windows Settings
  return ($isControlPanelDisabled.NoControlPanel, $isWindowsSettingsDisabled.NoWindowsSettings)
}

# Function to disable both the Control Panel and Windows Settings
Function Disable-Settings {
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Accessibility" -Name "NoControlPanel" -Value 0 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings" -Value 1 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Settings\Accessibility" -Name "NoWindowsSettings" -Value 0 -PropertyType DWORD
  Write-Host "Both the Control Panel and Windows Settings have been disabled, except for the Ease of Access settings."
}

# Function to enable both the Control Panel and Windows Settings
Function Enable-Settings {
  Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
  Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings"
  Write-Host "Both the Control Panel and Windows Settings have been re-enabled."
}

# Get the current state of the Control Panel and Windows Settings
$controlPanelState, $windowsSettingsState = Check-SettingsState

# If both the Control Panel and Windows Settings are disabled, enable them
if ($controlPanelState -eq 1 -and $windowsSettingsState -eq 1) {
  Enable-Settings
}
# If both the Control Panel and Windows Settings are enabled, disable them
elseif ($controlPanelState -eq 0 -and $windowsSettingsState -eq 0) {
  Disable-Settings
}
# If the Control Panel and Windows Settings are unsynchronized, resynchronize them by disabling or enabling them both
else {
  Write-Host "The Control Panel and Windows Settings are unsynchronized."
  if ($controlPanelState -eq 1) {
    Disable-Settings
  }
  else {
    Enable-Settings
  }
}
