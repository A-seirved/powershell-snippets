$VerbosePreference = "Continue"

if (!(Test-Path 'HKCU:\Control Panel\Accessibility\')) {
  Write-Verbose "Control Panel\Accessibility key does not exist"
  return
}
if (!(Test-Path 'HKCU:\Control Panel\Accessibility\NoWindowsSettings')) {
  Write-Verbose "NoWindowsSettings key does not exist"
  return
}
if (!(Test-Path 'HKCU:\Control Panel\Accessibility\NoControlPanel')) {
  Write-Verbose "NoControlPanel key does not exist"
  return
}


# Function to check the state of the Control Panel and Windows Settings
Function Check-SettingsState {
  $isControlPanelDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
  $isWindowsSettingsDisabled = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings"

  # Return the state of the Control Panel and Windows Settings
  return ($isControlPanelDisabled.NoControlPanel, $isWindowsSettingsDisabled.NoWindowsSettings)
}

# Function to disable the Control Panel and Windows Settings, except for the Ease of Access settings
Function Disable-Settings {
  if (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel") {
    Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1
    Write-Verbose "The Control Panel has been disabled."
  } else {
    Write-Verbose "The NoControlPanel property does not exist."
  }
  if (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Accessibility\NoControlPanel") {
    Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Accessibility" -Name "NoControlPanel" -Value 0
    Write-Verbose "The Ease of Access settings in Control Panel has been enabled."
  } else {
    Write-Verbose "The NoControlPanel property for Ease of Access settings does not exist."
  }
  if (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsSettings") {
    Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWindowsSettings" -Value 1
    Write-Verbose "The Windows Settings has been disabled."
  } else {
    Write-Verbose "The NoWindowsSettings property does not exist."
  }
  if (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Settings\Accessibility\NoWindowsSettings") {
    Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Settings\Accessibility" -Name "NoWindowsSettings" -Value 0
    Write-Verbose "The Ease of Access settings in Windows Settings has been enabled."
  } else {
    Write-Verbose "The NoWindowsSettings property for Ease of Access settings does not exist."
  }
}

# Function to enable the Control Panel and Windows Settings
Function Enable-Settings {
  if (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel") {
    Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel"
    Write-Verbose "The Control Panel has been re-enabled."
  } else {
    Write-Verbose "The NoControlPanel property does not exist."
  }
}


# Check the status of Windows Settings
$SettingsValue = Get-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoWindowsSettings
$SettingsLocked = $SettingsValue.NoWindowsSettings

# Check the status of Control Panel
$ControlValue = Get-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoControlPanel
$ControlLocked = $ControlValue.NoControlPanel

# Check if both settings are in the same state (locked or unlocked)
if ($SettingsLocked -eq $ControlLocked) {

  Write-Verbose "Settings are in sync"

  # If both settings are already locked, unlock them
  if ($SettingsLocked -eq 1) {
    Write-Verbose "Settings are locked, unlocking..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoWindowsSettings -Value 0
    Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoControlPanel -Value 0
  }
  # If both settings are already unlocked, lock them
  else {
    Write-Verbose "Settings are unlocked, locking..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoWindowsSettings -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoControlPanel -Value 1
  }
}
# If both settings are in different states, synchronize them
else {
  Write-Verbose "Settings are not in sync, synchronizing..."

  # If Windows Settings is locked and Control Panel is unlocked, lock Control Panel
  if ($SettingsLocked -eq 1 -and $ControlLocked -eq 0) {
    Write-Verbose "Windows Settings is locked, Control Panel is unlocked, locking Control Panel..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoControlPanel -Value 1
  }
  # If Windows Settings is unlocked and Control Panel is locked, unlock Control Panel
  else {
    Write-Verbose "Windows Settings is unlocked, Control Panel is locked, unlocking Control Panel..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoControlPanel -Value 0
  }

  # Set Windows Settings to the same state as Control Panel
  Write-Verbose "Setting Windows Settings to the same state as Control Panel..."
  Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\' -Name NoWindowsSettings -Value $ControlLocked
}

