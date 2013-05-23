#!/bin/bash

clear;
echo "[1] Lister les cartes réseaux et leur config"
echo "[2] Changer l'@ ip d'une carte"
echo "[3] Activer/Désactiver une carte"
echo "[4] Changer le serveur DNS"
echo "[5] Changer le nom de la machine"
echo "[6] Redémarrer le service réseau"

echo "Tapez votre choix :"
read choix

case $choix in
  1) echo "Lister les cartes"
    ifconfig -a;;
  2) echo "Changer l'adress ip d'une carte";;
  3) echo "Activer/Désactiver une carte";;
  4) echo "Changer le serveur dns";;
  5) echo "Changer le nom de la machine";;
  6) echo "Redemarrage du service réseau ...";
    /etc/init.d/networkmanager restart;;
  *) echo "Retour ..."
esac
