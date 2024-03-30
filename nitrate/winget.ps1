<#    nitrate92's winget script. This applies to a less broad amount of people, but can be good for you if you want 
      somewhere to start from if you are creating a small set of automation scripts like I am.
      Note: I don't know if I have to append "--accept-package-agreements" to everything but I will because it shouldn't hurt anything. #>

<#  Now seperated by line, because I felt like it
    9p7knl5rwt25 = sysinternals
    9N0DX20HK701 = windows terminal #>
$theShitWinget = "Microsoft.PowerToys",
"9p7knl5rwt25",
"7zip.7zip",
"9N0DX20HK701",
"VSCodium.VSCodium",
"Mozilla.Firefox",
"Valve.Steam",
"Discord.Discord",
"CrystalDewWorld.CrystalDiskInfo",
"VideoLAN.VLC",
"RealVNC.VNCViewer",
"WiresharkFoundation.Wireshark",
"Git.Git",
"GitHub.GitHubDesktop",
"AngusJohnson.ResourceHacker",
"BleachBit.BleachBit",
"KeePassXCTeam.KeePassXC",
"RaspberryPiFoundation.RaspberryPiImager",
"ShareX.ShareX",
"Mobatek.MobaXterm",
"OBSProject.OBSStudio",
"Insecure.Npcap",
"LIGHTNINGUK.ImgBurn",
"DuongDieuPhap.ImageGlass",
"yt-dlp.yt-dlp",
"cURL.cURL",
"GNU.Wget2",
"Python.Python.3.11",
"qBittorrent.qBittorrent"

# 549981C3F5F10 = Cortana
$theShitUWP = "Microsoft.WindowsCamera", "Microsoft.ZuneMusic", "Microsoft.Xbox.TCUI", "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay", "Microsoft.WindowsMaps", "Microsoft.People", "Microsoft.549981C3F5F10", "Microsoft.YourPhone"

$elevated = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match 'S-1-5-32-544'
if (-not $elevated) {
  Write-Host "This script requires administrative privileges. Please run it again in an elevated command prompt." -ForegroundColor Red
  exit
}

# This code belongs to Den Delimarsky, props to him
function Show-Notification {
  [cmdletbinding()]
  Param (
      [string]
      $ToastTitle,
      [string]
      [parameter(ValueFromPipeline)]
      $ToastText
  )

  [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
  $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

  $RawXml = [xml] $Template.GetXml()
  ($RawXml.toast.visual.binding.text|Where-Object {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
  ($RawXml.toast.visual.binding.text|Where-Object {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

  $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
  $SerializedXml.LoadXml($RawXml.OuterXml)

  $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
  $Toast.Tag = "PowerShell"
  $Toast.Group = "PowerShell"
  $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

  $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
  $Notifier.Show($Toast);
}

Write-Host "The following will be installed:"
foreach ($package in $theShitWinget) {
  Write-Host "$package" -ForegroundColor Yellow
}
Read-Host -Prompt "Press any key to continue"
foreach ($package in $theShitWinget) {
  winget install $package --accept-package-agreements
}
"Done installing applications" | Show-Notification -ToastTitle "Winget Script"
Read-Host -Prompt "Done, press any key to proceed to UWP app uninstallation"
Write-Host "The following will be uninstalled:"
foreach ($UWP in $theShitUWP) {
  Write-Host "$UWP" -ForegroundColor Yellow
}
Read-Host -Prompt "Press any key to continue"
Write-Host "Backing up list of all installed UWP applications. File will be placed under the current directory for this PowerShell instance."
Get-AppxPackage -AllUsers > InstalledBefore.txt # i never realized this before but apparently i was using character U+2013 which can be confused with U+002d and caused me a few headaches
Write-Host "Removing applications"
foreach ($UWP in $theShitUWP) {
  Get-AppxPackage $UWP -AllUsers | Remove-AppxPackage
}
"Done uninstalling UWP applications" | Show-Notification -ToastTitle "Winget Script"
Read-Host -Prompt "Done, press any key to exit"