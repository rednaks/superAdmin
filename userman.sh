#!/bin/bash


GlobalGName = ""
createGroup(){
  #saisie du nom du groupe 
  while true
  do
    echo "Donner ne nom du groupe que vous voulez créer"
    read gname
    if [ -z "$gname" ]
    then
      echo "Vous devez spécifer le nom du groupe"
    elif [ -n "$(grep $gname /etc/group)" ]
    then
      echo "Ce groupe existe déjà"
    else
      echo "groupadd $gname"
      break
    fi
  done

  GlobalGName=$gname
}
createUser(){
  clear;
  echo "** Création d'utilisateur";

  #saisie du nom d'utilisateur
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

  #saisie du mot de passe
  while true
  do
    echo "Entrez le mot de passe associé :";
    read -s password
    if [ -z "$password" ]
    then
      echo "Vous devez enter un mot de passe"
    else
      break
    fi
  done

  #choix du groupe
  echo "Voulez vous préciser les groupes ? [O/N]";
  read yn
  case $yn in
    [Oo]) echo "Lister les groupes";
        gp=(`groups`)
        compt=0
        for g in "${gp[@]}"
        do
          echo "[$compt] $g"""
          let compt++
        done
        echo "[$compt] Créer un nouveau groupe"
        while true
        do
          echo "Votre choix:"
          read gchoix
          if [ $gchoix -le $compt ]
          then
            break
          fi
        done
        if [ $gchoix -eq $compt ]
        then
          createGroup
          gname=$GlobalGName
        else
          gname=${gp[$gchoix]}
        fi
        ;;
       *) echo "Groupe ne sera pas spécifié";;
  esac
  if [ -n "$gname" ]
  then
    gopt="-G $gname"
  fi
  echo "useradd $uname -p $password $gopt"
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
  5) echo -e "Retour...";
    exit 0;;
  6) echo -e "Quit";;
  *) echo -e "Ce choix n'existe pas...";;
esac




