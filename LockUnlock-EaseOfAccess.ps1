$ControlPanelKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Settings"
$WindowsSettingsKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Settings"

If (!(Test-Path $ControlPanelKey)) {
    New-Item -Path $ControlPanelKey -Force | Out-Null
    New-ItemProperty -Path $ControlPanelKey -Name "NoControlPanel" -Value 1 -PropertyType DWord | Out-Null
}

If (!(Test-Path $WindowsSettingsKey)) {
    New-Item -Path $WindowsSettingsKey -Force | Out-Null
    New-ItemProperty -Path $WindowsSettingsKey -Name "NoWindowsSettings" -Value 1 -PropertyType DWord | Out-Null
}

$ControlPanelValue = Get-ItemPropertyValue -Path $ControlPanelKey -Name "NoControlPanel"
$WindowsSettingsValue = Get-ItemPropertyValue -Path $WindowsSettingsKey -Name "NoWindowsSettings"

If ($ControlPanelValue -eq $WindowsSettingsValue) {
    If ($ControlPanelValue -ne 0) {
        Set-ItemProperty -Path $ControlPanelKey -Name "NoControlPanel" -Value 0
        Set-ItemProperty -Path $WindowsSettingsKey -Name "NoWindowsSettings" -Value 0
    }
}
Else {
    $ControlPanelValue = Get-ItemPropertyValue -Path $ControlPanelKey -Name "NoControlPanel"
    $WindowsSettingsValue = Get-ItemPropertyValue -Path $WindowsSettingsKey -Name "NoWindowsSettings"

    If ($ControlPanelValue -ne $WindowsSettingsValue) {
        If ($ControlPanelValue -ne 0) {
            Set-ItemProperty -Path $ControlPanelKey -Name "NoControlPanel" -Value $WindowsSettingsValue
        }
        If ($WindowsSettingsValue -ne 0) {
            Set-ItemProperty -Path $WindowsSettingsKey -Name "NoWindowsSettings" -Value $ControlPanelValue
        }
    }
}
