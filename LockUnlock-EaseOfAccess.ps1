# Function to check the state of the Control Panel and Windows Settings
Function Check-SettingsState {
  $isControlPanelDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
  $isWindowsSettingsDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings"

  # Return the state of the Control Panel and Windows Settings
  return ($isControlPanelDisabled.NoControlPanel, $isWindowsSettingsDisabled.NoWindowsSettings)
}

# Function to disable the Control Panel and Windows Settings, except for the Ease of Access settings
Function Disable-Settings {
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Accessibility" -Name "NoControlPanel" -Value 0 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings" -Value 1 -PropertyType DWORD
  New-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Settings\Accessibility" -Name "NoWindowsSettings" -Value 0 -PropertyType DWORD
  Write-Host "The Control Panel and Windows Settings have been disabled, except for the Ease of Access settings."
}

# Function to enable the Control Panel and Windows Settings
Function Enable-Settings {
  Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
  Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings"
  Write-Host "The Control Panel and Windows Settings have been re-enabled."
}

# Function to synchronize the Control Panel and Windows Settings state
Function Synchronize-Settings {
  $controlPanelState, $windowsSettingsState = Check-SettingsState
  if ($controlPanelState -ne $windowsSettingsState) {
    if ($controlPanelState -eq 1) {
      Disable-Settings
    } else {
      Enable-Settings
    }
  }
}

# Get the current state of the Control Panel and Windows Settings
$controlPanelState, $windowsSettingsState = Check-SettingsState

# If the Control Panel and Windows Settings are enabled, disable them
if ($controlPanelState -eq 0 -and $windowsSettingsState -eq 0) {
  Disable-Settings
}
# If the Control Panel and Windows Settings are disabled, enable them
else {
  Enable-Settings
}

# Synchronize the Control Panel and Windows Settings state
Synchronize-Settings
