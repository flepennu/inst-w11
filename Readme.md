# Ensemble de fichiers permettant de produire une clé USB d'installation de Windows 11

Basé sur ventoy voir a :www.ventoy.com

Application qui permet de générer une clé de boot et de lancer apres un iso, plutot que de dédier la clé a la copie du contenu de l'iso.

  Le fichier windows11.iso doit etre téléchargé séparement depuis :https://www.microsoft.com/fr-fr/software-download//windows11

on utilise un fichier unattended.xml d'installation automatique que l'on copie dans le repertoire scripts

généré depuis le site : https://schneegans.de/windows/unattend-generator/

Celui-ci copie les fichiers presents dans le répertoire info de la clé 

Puis lance : info/choco-ep.ps1

Qui installe avec chocolatey un ensemble d'outils de base

Structure de la clé :

racine
  -info
  -scripts
  windows11.iso

