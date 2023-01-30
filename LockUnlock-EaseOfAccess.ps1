# Set registry key paths as variables
$NoCPL = "HKEY_CURRENT_USER\Control Panel\NoCPL"
$NoSettings = "HKEY_CURRENT_USER\Control Panel\NoSettings"

# Create the registry keys if they don't exist and set them to a default state of everything enabled
if (!(Test-Path $NoCPL)) {
  New-Item -Path "HKEY_CURRENT_USER\Control Panel" -Name "NoCPL"
  Set-ItemProperty -Path $NoCPL -Name "0" -Value 0
}

if (!(Test-Path $NoSettings)) {
  New-Item -Path "HKEY_CURRENT_USER\Control Panel" -Name "NoSettings"
  Set-ItemProperty -Path $NoSettings -Name "0" -Value 0
}

# Disable everything except the Ease of Access settings
Set-ItemProperty -Path $NoCPL -Name "0" -Value 1
Set-ItemProperty -Path $NoSettings -Name "1" -Value 1

# Function to resynchronize registry keys
function ResyncKeys {
  $NoCPLVal = Get-ItemProperty -Path $NoCPL -Name "0"
  $NoSettingsVal = Get-ItemProperty -Path $NoSettings -Name "1"
  if ($NoCPLVal.0 -ne $NoSettingsVal.1) {
    Set-ItemProperty -Path $NoCPL -Name "0" -Value $NoSettingsVal.1
    Set-ItemProperty -Path $NoSettings -Name "1" -Value $NoCPLVal.0
  }
}

# Call the resynchronization function
ResyncKeys
