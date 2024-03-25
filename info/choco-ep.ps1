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
if(Test-Path $Pasdodo){
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
choco install vcredist140 vcredist2008 vcredist2012 vcredist2015 vcredist2017 -y
# Display link si c'est un portable
if ($pctype -like "Mobil*"){
    # c'est un portable
	Write-Host "Le pc est portable !"
	choco install displaylink -y
}
# programmes utiles
choco install treesizefree powertoys 7zip notepadplusplus vlc openshot filezilla jabra-direct -y
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
# on fini en forcant la maj de windows
Install-WindowsUpdate -AcceptAll

$NomMachine = Read-Host 'quel sera le nom de cette machine ?'
Rename-Computer -NewName $NomMachine