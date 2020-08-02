#Requires -RunAsAdministrator
param([string]$HostAddr)
if ($HostAddr -eq $null) { Write-Host "No host address provided"; exit }

# using Env:WinDir just in case our Windows folder is not on C: drive
$hostsFilePath = $Env:WinDir+'\system32\Drivers\etc\hosts'
# Hostname(s) being added, space delimited
$hostNames = "wslfqdn.local"
# Obviously special characters like spaces and periods need to be escaped
$escapedHostNames = [Regex]::Escape($HostNames)
# Remove old IP for the host name(s)
(Get-Content $hostsFilePath) -notmatch ".*\s+$escapedHostNames.*" | Out-File $hostsFilePath
# Add current IP for the host name(s). Padding is strictly for visual alignment and is not necessary
Add-Content -Encoding UTF8 $hostsFilePath ("$HostAddr".PadRight(16, " ") + $hostNames)
