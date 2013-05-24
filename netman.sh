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

changeHostname() {
  echo "Donner un nom pour la machine : "
  read name
  hostname $name
}

upDown(){
  ifs=(`ifconfig | grep -i link | awk '{print $1}'`)
  compt=0
  for i in "${ifs[@]}"
  do
    echo "[$compt] $i"""
    let compt++
  done
  echo "Choisir le numéro de la carte : "
  read choix
  
  echo "[1] Activer la carte"
  echo "[2] Désactiver la carte"
  echo "Que vous les vous faire ?"
  read choix2
  case $choix2 in 
    1) cmd="up";;
    2) cmd="down";;
  esac
    ifconfig ${ifs[$choix]} $cmd
}

chDns(){
  echo "Donner la nouvelle addresse du serveur de noms: "
  read addr
  sed '/nameserver/d' /etc/resolv.conf > /etc/resolv.conf
  echo "nameserver $addr" >> /etc/resolv.conf
}

ipConfig() {
  ifs=(`ifconfig | grep -i link | awk '{print $1}'`)
  compt=0
  for i in "${ifs[@]}"
  do
    echo "[$compt] $i"""
    let compt++
  done
  echo "Choisir le numéro de la carte : "
  read choix
  echo "Donner la nouvelle adresse ip : "
  read ipaddr
  echo "Donner le masque :"
  read ipmask
  echo "Donner la passerelle par défaut : "
  read ipgw
  
  ifconfig ${ifs[$compt]} $ipaddr netmask $ipmask
  route add default gw $ipgw

 
}
case $choix in
  1) echo "Lister les cartes"
    ifconfig -a;;
  2) echo "Changer l'adress ip d'une carte";
    ipConfig;;
  3) echo "Activer/Désactiver une carte";
    upDown;;
  4) echo "Changer le serveur dns";
    chDns;;
  5) echo "Changer le nom de la machine";
    changeHostname;;
  6) echo "Redemarrage du service réseau ...";
    /etc/init.d/networkmanager restart;;
  *) echo "Retour ..."
esac
