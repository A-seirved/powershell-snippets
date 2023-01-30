# Check if the keys exist
if ((Test-Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System') -and (Test-Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer')) {
    $Val = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'NoControlPanel'
    Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'NoControlPanel' -Value $Val.NoControlPanel
    Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWindowsSettings' -Value $Val.NoControlPanel
} else {
    Write-Host 'Registry keys not found'
}

# Resync function
Function Resync {
    $Val1 = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'NoControlPanel'
    $Val2 = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWindowsSettings'
    if ($Val1.NoControlPanel -ne $Val2.NoWindowsSettings) {
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'NoControlPanel' -Value $Val2.NoWindowsSettings
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWindowsSettings' -Value $Val2.NoWindowsSettings
    }
}

# Call the resync function
Resync
