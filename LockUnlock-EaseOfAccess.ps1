$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$NoControlPanel = "NoControlPanel"
$NoWindowsSettings = "NoWindowsSettings"
$EaseOfAccess = "NoSettingsApp"

$NoControlPanelValue = Get-ItemProperty -Path $registryPath -Name $NoControlPanel
$NoWindowsSettingsValue = Get-ItemProperty -Path $registryPath -Name $NoWindowsSettings

if (!(Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $NoControlPanel -Value 1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $NoWindowsSettings -Value 1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $EaseOfAccess -Value 0 -PropertyType DWORD -Force | Out-Null
} else {
    if ($NoControlPanelValue -eq $null) {
        New-ItemProperty -Path $registryPath -Name $NoControlPanel -Value 1 -PropertyType DWORD -Force | Out-Null
    } else {
        Set-ItemProperty -Path $registryPath -Name $NoControlPanel -Value 1
    }
    if ($NoWindowsSettingsValue -eq $null) {
        New-ItemProperty -Path $registryPath -Name $NoWindowsSettings -Value 1 -PropertyType DWORD -Force | Out-Null
    } else {
        Set-ItemProperty -Path $registryPath -Name $NoWindowsSettings -Value 1
    }
    if ($EaseOfAccessValue -eq $null) {
        New-ItemProperty -Path $registryPath -Name $EaseOfAccess -Value 0 -PropertyType DWORD -Force | Out-Null
    } else {
        Set-ItemProperty -Path $registryPath -Name $EaseOfAccess -Value 0
    }
}

$NoControlPanelCheck = Get-ItemProperty -Path $registryPath -Name $NoControlPanel
$NoWindowsSettingsCheck = Get-ItemProperty -Path $registryPath -Name $NoWindowsSettings
$EaseOfAccessCheck = Get-ItemProperty -Path $registryPath -Name $EaseOfAccess

if ($NoControlPanelCheck.NoControlPanel -ne 1 -or $NoWindowsSettingsCheck.NoWindowsSettings -ne 1 -or $EaseOfAccessCheck.EaseOfAccess -ne 0) {
    Write-Output "Registry keys are out of sync. Running resync procedure."
    Set-ItemProperty -Path $registryPath -Name $NoControlPanel -Value 1
    Set-ItemProperty -Path $registryPath -Name $NoWindowsSettings -Value 1
    Set-ItemProperty -Path $registryPath -Name $EaseOfAccess -Value 0
}
