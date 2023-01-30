# Disable Windows settings
Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies" | ForEach-Object {
  if ($_.Name -ne "Control Panel") {
    New-ItemProperty -Path $_.PSPath -Name "NoControlPanel" -Value 1 -PropertyType DWORD
  }
}
Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" | ForEach-Object {
  New-ItemProperty -Path $_.PSPath -Name "Hidden" -Value 1 -PropertyType DWORD
  New-ItemProperty -Path $_.PSPath -Name "Start_ShowControlPanel" -Value 0 -PropertyType DWORD
}

# Enable Ease of Access settings
Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Control Panel\Accessibility" | ForEach-Object {
  New-ItemProperty -Path $_.PSPath -Name "NoControlPanel" -Value 0 -PropertyType DWORD
}
