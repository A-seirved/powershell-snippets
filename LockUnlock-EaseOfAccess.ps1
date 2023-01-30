# Set the registry key paths
$controlPanelKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$settingsKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"

# Check if the keys exist, if not create them with default values
if (!(Test-Path $controlPanelKey)) {
  New-Item -Path $controlPanelKey -Force | Out-Null
  New-ItemProperty -Path $controlPanelKey -Name "NoControlPanel" -Value 0 -PropertyType DWORD -Force | Out-Null
}
if (!(Test-Path $settingsKey)) {
  New-Item -Path $settingsKey -Force | Out-Null
  New-ItemProperty -Path $settingsKey -Name "NoWindowsSettings" -Value 0 -PropertyType DWORD -Force | Out-Null
}

# Disable everything but Ease of Access
Set-ItemProperty -Path $controlPanelKey -Name "NoControlPanel" -Value 1
Set-ItemProperty -Path $settingsKey -Name "NoWindowsSettings" -Value 1

# Function to resync the registry keys
function Resync {
  # Get the values of the registry keys
  $controlPanelValue = (Get-ItemProperty -Path $controlPanelKey).NoControlPanel
  $settingsValue = (Get-ItemProperty -Path $settingsKey).NoWindowsSettings

  # Check if the values are not in sync
  if ($controlPanelValue -ne $settingsValue) {
    # Set both values to the same value
    Set-ItemProperty -Path $controlPanelKey -Name "NoControlPanel" -Value $settingsValue
    Set-ItemProperty -Path $settingsKey -Name "NoWindowsSettings" -Value $settingsValue
  }
}
