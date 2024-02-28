# winget installation script. Mainly intended for LTSC, since that doesn't come with it preinstalled OOTB.

$elevated = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match 'S-1-5-32-544'
if (-not $elevated) {
	Write-Host "This script requires administrative privileges. Please run it again in an elevated command prompt." -ForegroundColor Red
	exit
}

$progressPreference = 'silentlyContinue'
Write-Information "Downloading and installing winget and its dependencies..."
Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.6.3133/b6e881d14bc943268a82d474bf7d15af_License1.xml -OutFile b6e881d14bc943268a82d474bf7d15af_License1.xml
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
# if it's hacky and you know it clap your hands!
Invoke-WebRequest -Uri "https://github.com/microsoft/terminal/releases/download/v1.19.10302.0/Microsoft.WindowsTerminal_1.19.10302.0_8wekyb3d8bbwe.msixbundle_Windows10_PreinstallKit.zip" -OutFile ".\Windows10_PreinstallKit.zip"; Expand-Archive -Path ".\Windows10_PreinstallKit.zip" -DestinationPath ".\Windows10_PreinstallKit" -Force; Move-Item -Path ".\Windows10_PreinstallKit\Microsoft.UI.Xaml.2.8_8.2310.30001.0_x64__8wekyb3d8bbwe.appx" -Destination .; Remove-Item -Path ".\Windows10_PreinstallKit.zip" -Force; Remove-Item -Path ".\Windows10_PreinstallKit" -Recurse -Force
Add-AppxPackage -Path Microsoft.UI.Xaml.2.8_8.2310.30001.0_x64__8wekyb3d8bbwe.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxProvisionedPackage -Online -PackagePath Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -LicensePath .\b6e881d14bc943268a82d474bf7d15af_License1.xml -Verbose
