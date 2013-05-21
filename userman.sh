#!/bin/bash


GlobalGName=""
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

deleteUsers() {
  while true
  do
    while true
    do
      echo "Donner le nom d'utilisateur que vous voulez supprimer:"
      read uname
      if [ -z "$uname" ]
      then 
        echo "Veuillez entrez un nom d'utilisateur"
      elif [ -z "$(grep $uname /etc/passwd)" ]
      then
        echo "Utilisateur n'exite pas"
      else
        break
      fi
    done
    echo "Voulez vous vraiment supprimer l'utilisateur $uname ? [O/N]"
    read choix
    case $choix in
      [Oo]) echo "Supression ...";
            echo "userdel -r $uname";;
         *) echo "Annulation ...";;
    esac

    echo "Voulez vous supprimer un autre utilisateur ? [O/N]"
    read suppChoix
    case $suppChoix in
      [Oo]) echo "Suppression d'un autre utilisateur ...";;
         *) echo "Fin.";
          break;;
    esac
  done
}


listAll(){
  users=(`cut -d: -f1 /etc/passwd`)
  for u in "${users[@]}"
  do
    id=$(echo "$(id -u $u)")
    if [ $id -gt 999 ]
    then
      echo "$u (simple)"
    else
      echo "$u (système)"
    fi
  done
}

listSimpleSys(){
  echo "[1] Lister les utilisateurs simples"
  echo "[2] Lister les utilisateurs système"
  echo "[3] Lister tout les utilisateurs"
  echo "[4] Retour"
  read choix

  case $choix in
    1) echo "Liste des utilisateurs simple";;
    2) echo "Liste des utilisateurs système";;
    3) echo "Liste de tout les utilisateurs";
       listAll;;
    4) echo "Retour ...";;
  esac
}
 
listUsers(){
 while true
  do
    echo "[1] Details sur un utilisateur"
    echo "[2] Lister les sessions ouvertes"
    echo "[3] Lister les utilisateurs (simple/système)"
    echo "[4] Retour"
    
    echo "Votre choix"
    read choix
    case $choix in
      1) echo "Details sur les utilisateurs";;
      2) echo "Lister les sessions ouvertes";;
      3) echo "Lister les utilisateurs simple ou sys";;
      4) echo "Retour ...";
        break;;
      *) echo "Ce choix n'existe pas !";;
    esac
  done
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
  2) echo -e "Supression des utilisateurs ...";
    deleteUsers;;
  3) echo -e "List des utilisateurs ...";
    listSimpleSys;;
  4) echo -e "Gestion des mots de passes...";;
  5) echo -e "Retour...";
    exit 0;;
  6) echo -e "Quit";
    exit 0;;
  *) echo -e "Ce choix n'existe pas...";;
esac




