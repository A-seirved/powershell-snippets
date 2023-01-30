$ControlPanelKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$SettingsKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

Function EnableSettings {
    If (!(Test-Path $ControlPanelKey)) {
        New-Item -Path $ControlPanelKey -Force | Out-Null
        New-ItemProperty -Path $ControlPanelKey -Name NoControlPanel -PropertyType DWORD -Value 0 -Force | Out-Null
    }
    If (!(Test-Path $SettingsKey)) {
        New-Item -Path $SettingsKey -Force | Out-Null
        New-ItemProperty -Path $SettingsKey -Name NoWindowsSettings -PropertyType DWORD -Value 0 -Force | Out-Null
    }
    Set-ItemProperty -Path $ControlPanelKey -Name NoControlPanel -Value 1
    Set-ItemProperty -Path $SettingsKey -Name NoWindowsSettings -Value 1
    Set-ItemProperty -Path $ControlPanelKey -Name NoClose -PropertyType DWORD -Value 0 -Force | Out-Null
}

Function DisableSettings {
    If (!(Test-Path $ControlPanelKey)) {
        New-Item -Path $ControlPanelKey -Force | Out-Null
    }
    If (!(Test-Path $SettingsKey)) {
        New-Item -Path $SettingsKey -Force | Out-Null
    }
    Set-ItemProperty -Path $ControlPanelKey -Name NoControlPanel -Value 1
    Set-ItemProperty -Path $SettingsKey -Name NoWindowsSettings -Value 1
    Set-ItemProperty -Path $ControlPanelKey -Name NoClose -PropertyType DWORD -Value 1 -Force | Out-Null
}

Function ResyncSettings {
    $ControlPanelSetting = Get-ItemProperty -Path $ControlPanelKey -Name NoControlPanel
    $SettingsSetting = Get-ItemProperty -Path $SettingsKey -Name NoWindowsSettings
    If ($ControlPanelSetting.NoControlPanel -ne $SettingsSetting.NoWindowsSettings) {
        If ($ControlPanelSetting.NoControlPanel -eq 1) {
            Set-ItemProperty -Path $SettingsKey -Name NoWindowsSettings -Value 1
        }
        Else {
            Set-ItemProperty -Path $ControlPanelKey -Name NoControlPanel -Value 0
        }
    }
}

If (!(Test-Path $ControlPanelKey) -or !(Test-Path $SettingsKey)) {
    EnableSettings
}
Else {
    DisableSettings
    ResyncSettings
}
