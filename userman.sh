#!/bin/bash

#############################################################################
#############################################################################
################### Begin Création d'utilisateur ############################
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

#############################################################################
#############################################################################
################### END Création d'utilisateur ##############################


#############################################################################
#############################################################################
################### Begin Supression d'utilisateur ##########################


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

#############################################################################
#############################################################################
################### END Supression d'utilisateur ##########################

#############################################################################
#############################################################################
################### Begin List d'utilisateur ##########################

listAll(){
  users=(`cut -d: -f1 /etc/passwd`)
  for u in "${users[@]}"
  do
    id=$(echo "$(id -u $u)")
    if [ $id -gt 999 -o $id -eq 0 ]
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
    1) echo "Liste des utilisateurs simple";
       listSimple;;
    2) echo "Liste des utilisateurs système";
      listSys;;
    3) echo "Liste de tout les utilisateurs";
       listAll;;
    4) echo "Retour ...";;
  esac
}
 
listSimple(){
  users=(`cut -d: -f1 /etc/passwd`)
  for u in "${users[@]}"
  do
    id=$(echo "$(id -u $u)")
    if [ $id -gt 999 -o $id -eq 0 ]
    then
      echo "$u (simple)"
    fi
  done
}

listSys(){
  users=(`cut -d: -f1 /etc/passwd`)
  for u in "${users[@]}"
  do
    id=$(echo "$(id -u $u)")
    if [ $id -lt 1000 -a $id -ne 0 ]
    then
      echo "$u (système)"
    fi
  done
}

listInfos() {
  echo "Donner le nom d'utilisateur :"
  read uname
  id $uname > /dev/null
  if [ $? -eq 0 ]
  then
    id=$(id -u $uname)
    home=$(grep ^$uname /etc/passwd | cut -d: -f6)
    shell=$(grep ^$uname /etc/passwd | cut -d: -f7)
    commentaire=$(grep ^$uname /etc/passwd | cut -d: -f5)
    echo -e "Infos de l'utilisateur $uname :"
    echo -e "login : $uname\nId : $id\nHome : $home\nShell : $shell\nCommentaire : $commentaire"
  fi
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
      1) echo "Details sur les utilisateurs";
        listInfos;;
      2) echo "Lister les sessions ouvertes";
        who | awk '{print $1 " est connecte sur " $2 " depuis " $3};';;
      3) echo "Lister les utilisateurs simple ou sys";
        listSimpleSys;;
      4) echo "Retour ...";
        break;;
      *) echo "Ce choix n'existe pas !";;
    esac
  done
}

#############################################################################
#############################################################################
################### END List d'utilisateur ##########################

#############################################################################
#############################################################################
################### Begin Passwords  ##########################################

protectUser() {
  while true
  do
    echo "Donner le nom d'utilisteur que vous voulez sécuriser :"
    read uname
    id $uname > /dev/null
    if [ $? -eq 0 ]
      break;
    else
      echo "Utilisateur n'existe pas"
    fi
  done
  passwd $uname

}

lockUnlockUser() {
  while true
  do
    echo "Donner le nom d'utilisteur que vous voulez sécuriser :"
    read uname
    id $uname > /dev/null
    if [ $? -eq 0 ]
    then
      break;
    else
      echo "Utilisateur n'existe pas"
    fi
  done
  status=$(passwd -S $uname | awk '{print $2}')
  if [ $status -eq "PS" ]
  then
    echo "Voulez vous Blocker l'utilisateur $uname ? [Y/N]"
    read choix
    case $choix in 
    [Yy]) echo "Blockage de l'utilisateur $uname"
          passwd -l $uname;;
       *) echo "Annulation ..."
    esac
  else 
    echo "Voulez vous déblocker l'utilisateur $uname ? [Y/N]"
    read choix
    case $choix in 
    [Yy]) echo "déblockage de l'utilisateur $uname"
          passwd -u $uname;;
       *) echo "Annulation ..."
    esac

  fi

}
passman() {
  echo "[1] Blocker/Déblocker un utilisateur"
  echo "[2] Protéger un compte avec un mot de passe"
  echo "[3] Retour"

  read choix

  case $choix in
    1) echo "Blocker/Déblocker un utilisateur";
      lockUnlockUser;;
    2) echo "Protéger un compte avec un mot de passe ...";
      protectUser;;
    3) echo "Retour ...";;
  esac
}
##################  END passwords ############################################

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
    listUsers;;
  4) echo -e "Gestion des mots de passes...";
    passman;;
  5) echo -e "Retour...";
    exit 0;;
  6) echo -e "Quit";
    exit 0;;
  *) echo -e "Ce choix n'existe pas...";;
esac




