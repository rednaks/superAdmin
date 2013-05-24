#!/bin/bash


rechercheLog() {
  echo "Donner le service que vous voulez voir"
  read service
  echo "Donner le degré [info|alert|crit|err|warn|notice|info|debug]"
  read deg
  echo "Donner le mot clé"
  read cle
  
}
clear;

echo "[1] Editer le fichier syslog.conf"
echo "[2] Rechercher un log"
echo "[3] Editer logrotate"
echo "[4] Retour"
echo "Quel est votre choix :"
read choix

case $choix in 
  1) vim /etc/rsyslog.conf;;
  2) echo "Recherche ..."
    rechercheLog;;
  3) vim /etc/logrotat.conf;;
  *) echo "choix n'existe pas";;
esac

