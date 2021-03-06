#Enable RDP
$RDPEnable = 1
$RDPFirewallOpen = 1
$NLAEnable = 1

# Remote Desktop Connections
$RDP = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy
$Result = $RDP.SetAllowTSConnections($RDPEnable,$RDPFirewallOpen)

if ($Result.ReturnValue -eq 0){
   Write-Host "Remote Connection settings changed sucessfully" -ForegroundColor Cyan
} else {
   Write-Host ("Failed to change Remote Connections setting(s), return code "+$Result.ReturnValue) -ForegroundColor Red
   exit
}

# NLA (Network Level Authentication)
$NLA = Get-WmiObject -Class Win32_TSGeneralSetting -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy -Filter "TerminalName='RDP-tcp'"
$NLA.SetUserAuthenticationRequired($NLAEnable)
$NLA = Get-WmiObject -Class Win32_TSGeneralSetting -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy -Filter "TerminalName='RDP-tcp'"
if ($NLA.UserAuthenticationRequired -eq $NLAEnable){
   Write-Host "NLA setting changed sucessfully" -ForegroundColor Cyan
} else {
   Write-Host "Failed to change NLA setting" -ForegroundColor Red
   exit
}