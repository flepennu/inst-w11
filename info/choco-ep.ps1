#
# Variables
# 
# chemin de de dontsleep
$Pasdodo = "c:\info\DontSleep_x64_Portable\DontSleep_x64_p.exe"
# chemin Dell command Update apres installation
$DellCU = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
#   On recupere la marque du fabricant
$manufacturer = (gwmi win32_computersystem).Manufacturer
# on determine si c'est un portable ou un pc
$pctype = (Get-Computerinfo).CsPCSystemType
#
# On lance dont sleep pour eviter la mise en veille
#
#
if (Test-Path $Pasdodo){
   Start-Process -FilePath $Pasdodo
}else{
   Write-Host "Le fichier DontSleep n'existe pas !"
}
#   Installation de logiciels
#
#   chocolatey le moteur
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#
#   Module de gestion de windows update
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force
# se souvenir des options en cas de montée de version
choco feature enable -n=useRememberedArgumentsForUpgrades
# runtime en tous genre
choco install dotnet dotnetfx -y
choco install jre8 -y
choco install KB2919355 KB2919442 KB2999226 KB3033929 KB3035131 -y
choco install vcredist140 vcredist-all -y
# Display link si c'est un portable
if ($pctype -like "Mobil*"){
    # c'est un portable
	Write-Host "Le pc est portable !"
	choco install displaylink -y
}
# programmes utiles
choco install treesizefree powertoys 7zip notepadplusplus vlc openshot filezilla jabra-direct -y
# programmes utiles
choco install teamviewer -y --ignore-checksums
# lecteurs pdf
choco install adobereader pdfxchangeeditor inkscape -y
# images
choco install paint.net gimp xnview -y
# navigateurs
choco install Firefox googlechrome -y
#
#  En fonction de la marque on installe le gestionnaire correspondant
#
if ($manufacturer -like "Dell*"){
    # c'est un dell
    "Ca doit etre un dell!"
	choco install dellcommandupdate -y
}
if ($manufacturer -like "HP*"){
    # c'est un HP
    "Ca doit etre un HP!"
	choco install hpsupportassistant -y
}
if ($manufacturer -like "LENO*"){
    # c'est un Lenovo
    "Ca doit etre un Lenovo!"
	choco install lenovo-thinkvantage-system-update -y
}
if ($manufacturer -like "FUJI*"){
    # c'est un Fujitsu
	choco install deskupdate -y
    "Ca doit etre un Fujitsu!"
}
# teams for work
#
choco install microsoft-teams-new-bootstrapper -y
# Office 365 business
#
choco install office365business -y
# lecteur de dwg de 2Go
choco install dwgtrueview --params="'/French'" -y
#
# si dell command update present le lance
#
if ($manufacturer -like "Dell*"){
    # c'est un dell
    if(Test-Path $DellCU){
			Start-Process -FilePath $DellCU -ArgumentList '/applyupdates -forceUpdate=enable'
	}else{
	Write-Host "Le fichier Dell command update n'existe pas !"
	}
}
#Installation application locale en exe et msi
if (Test-Path "c:\info\SophosConnect_2.2.90_IPsec_and_SSLVPN.msi"){
   Start-Process -FilePath "msiexec /i c:\info\SophosConnect_2.2.90_IPsec_and_SSLVPN.msi /quiet /qn /norestart" -NoNewWindow -Wait -PassThru $process.ExitCode
}else{
   Write-Host "SophosConnect_2.2.90_IPsec_and_SSLVPN.msi n'existe pas !"
}
if (Test-Path "c:\info\Collaboration-x64.msi"){
   Start-Process -FilePath "msiexec /i c:\info\Collaboration-x64.msi /quiet /qn /norestart" -NoNewWindow -Wait -PassThru $process.ExitCode
}else{
   Write-Host "Wildix Collaboration-x64.msi n'existe pas !"
}

Write-Host "Desactivation Game Bar"
$p="HKLM\SOFTWARE\Polices\Microsoft\Windows\GameDVR"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "AllowGameDVR" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue
$p="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "AppCaptureEnabled" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue
$p="HKCU\SOFTWARE\Microsoft\GameBar"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "UseNexusForGameBarEnabled" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue
$p="HKCU\SOFTWARE\Microsoft\GameBar"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "ShowStartupPanel" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue
Write-Host "Menu clic-droit classique"
$p="HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "InprocServer32" -Value "0" -Type SZ -force -ErrorAction SilentlyContinue
Write-Host "rajouter fin de tache au clic-droit"
$p="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "TaskbarEndTask" -Value "1" -Type DWORD -force -ErrorAction SilentlyContinue
Write-Host "deplacer la barre des taches a gauche"
$p="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "TaskbarAl" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue
Write-Host "Montre les extensions de fichiers"
$p="HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "HideFileExt" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue
Write-Host "Activiation BSOD details"
$p="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if(!(Test-Path $p)){ni $p}; New-ItemProperty $p -Name "DisplayParameters" -Value "0" -Type DWORD -force -ErrorAction SilentlyContinue

# on fini en forcant la maj de windows
Install-WindowsUpdate -AcceptAll

$NomMachine = Read-Host 'quel sera le nom de cette machine ?'
Rename-Computer -NewName $NomMachine
Write-Host "On tue dont sleep"
$p = Get-Process -Name "DontSleep_x64_p"
Stop-Process -InputObject $p
Get-Process | Where-Object {$_.HasExited}
Write-Host "#=======================================================#"
Write-Host "#======================REDEMARRAGE======================#"
Write-Host "#=======================================================#"
Restart-Computer