#!/bin/bash

createUser(){
  clear;
  echo "** Création d'utilisateur";
  while true
  do
    echo "Entrez le nom d'utilisateur :";
    read uname;
    if [ -z "$uname" ]
    then
      echo "Vous devez entez un nom d'utilisateur"
    elif [ -n "$(grep $uname /etc/passwd)" ]
    then
      echo "Cet utilisateur existe déjà"
    else
      break
    fi
  done
  echo "Entrez le mot de passe associé :";
  read -s password;
  echo "Voulez vous préciser les groupes ? [O/N]";
  read yn
  case $yn in
    [Oo]) echo "Lister les groupes";;
    [Nn]) echo "Continuer";;
       *) echo "Ce choix n'existe pas";;
  esac
}

clear;
echo "[1] Créer un utilisateur"
echo "[2] Supprimer des utilisateurs"
echo "[3] Lister des utilisateurs"
echo "[4] Gérer les mots de passes"
echo "[5] Retour"
echo "[6] Quitter"

read choix

case $choix in
  1) echo -e "Création d'un utilisateur ...";
    createUser;;
  2) echo -e "Supression des utilisateurs ...";;
  3) echo -e "List des utilisateurs ...";;
  4) echo -e "Gestion des mots de passes...";;
  5) echo -e "Retour...";;
  6) echo -e "Quit";;
  *) echo -e "Ce choix n'existe pas...";;
esac




