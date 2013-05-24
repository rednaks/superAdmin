#!/bin/bash

clear;
echo "[1]Tâches système"
echo "[2]Tâches utilisateur"
echo "[3]Tâches At"
echo "[4]Lister les taches"
echo "[5]Supprimer une tache AT"
echo "[6]Retour ..."

customCron() {
  cmd=$1
  echo "Pour plannifier une tache on va donner l'heure, les minutes, le jour du mois, le mois, le jours de la semaine et enfin la commande à plannifer"
  echo "Donner l'heure, tapez * si vous ne voulez pas spécifier"
  read h
  echo "Donner la minute, tapez * si vous ne voulez pas spécifier"
  read m
  echo "Donner le jour du mois, tapez * si vous ne voulez pas spécifier"
  read jmois
  echo "Donner le mois, tapez * si vous ne voulez pas spécifier"
  read mois
  echo "Donner le jour de la semaine, tapez * si vous ne voulez pas spécifier"
  read jsem
  echo "$m $h $jmois $mois $jsem $cmd" >> /etc/crontab/$uname

}
ajouterTacheSys() {
  echo "Quel genre de tache voulez vous plannifer ?"
  echo "[1] Chaque heure"
  echo "[2] Chaque jour"
  echo "[3] Chaque semaine"
  echo "[4] Chaque mois"
  echo "[5] Personnalisée"
  
  echo "Tapez votre choix :"
  read choix

  echo "Donner le nom de la tache :"
  read nomTache
  echo "Tapez la commande à plannifer:"
  read cmd
  case $choix in 
  1) echo "Plannification de $cmd chaque heure";
    touch /etc/cron.hourly/$nomTache;
    chmod +x /etc/cron.hourly/$nomTache;
    echo "#!/bin/bash" >> /etc/cron.hourly/$nomTache;
    echo "$cmd" >> /etc/cron.hourly/$nomTache;;
  2) echo "Plannification de $cmd chaque jour"
    touch /etc/cron.daily/$nomTache;
    chmod +x /etc/cron.daily/$nomTache;
    echo "#!/bin/bash" >> /etc/cron.daily/$nomTache;
    echo "$cmd" >> /etc/cron.daily/$nomTache;;
 
  3) echo "Plannification de $cmd chaque semaine"
    touch /etc/cron.weekly/$nomTache;
    chmod +x /etc/cron.weekly/$nomTache;
    echo "#!/bin/bash" >> /etc/cron.weekly/$nomTache;
    echo "$cmd" >> /etc/cron.weekly/$nomTache;;
  4) echo "Plannification de $cmd chaque mois"
    touch /etc/cron.monthly/$nomTache;
    chmod +x /etc/cron.monthly/$nomTache;
    echo "#!/bin/bash" >> /etc/cron.monthly/$nomTache;
    echo "$cmd" >> /etc/cron.monthly/$nomTache;;
  5) echo "Plannification Personnalisée"
    customCron $cmd;;
  esac

}

plannifierTache () {
  uname=$1
  echo "Pour plannifier une tache on va donner l'heure, les minutes, le jour du mois, le mois, le jours de la semaine et enfin la commande à plannifer"
  echo "Donner l'heure, tapez * si vous ne voulez pas spécifier"
  read h
  echo "Donner la minute, tapez * si vous ne voulez pas spécifier"
  read m
  echo "Donner le jour du mois, tapez * si vous ne voulez pas spécifier"
  read jmois
  echo "Donner le mois, tapez * si vous ne voulez pas spécifier"
  read mois
  echo "Donner le jour de la semaine, tapez * si vous ne voulez pas spécifier"
  read jsem
  echo "Donner la commande à exécuter"
  read cmd
  echo "$m $h $jmois $mois $jsem $cmd" >> /var/spool/cron/$uname

}

ajouterTacheUser() {
  echo "Ajout d'une tache cron pour un simple utilisateur"
  echo "Donner le nom d'utilisateur"
  read uname
  id -u $uname >> /dev/null
  if [ $? -eq 0 ]
  then
    echo "Donner la tache cron que vous voulez plannifer"
    plannifierTache $uname
  else
    echo "Cet utilisateur n'existe pas"
  fi
}

ajouterTacheAt() {
  echo "Donner l'heure à laquelle la tache va être exécuté :"
  read atime
  echo "N'oubliez pas qu'il faut appuier sur CTRL+D si vous avez fini d'ajouter les tache !"
  at $atime
}

listTache() {
  echo "[1] cron"
  echo "[2] at"
  echo "Quel type de taches voulez vous afficher :"
  read choix
  echo "Le nom d'utilisateur :"
  read uname
  id -u $uname >> /dev/null
  if [ $? -eq 0 ]
  then
    case $choix in
    1)
      crontab -u $uname -l;;
    2) 
      atq | grep $uname
    esac
  else
    echo "Utilisateur n'existe pas"
  fi
}
echo "Quel est votre choix :"
read choix

supprimerTache() {
  atq
  echo "Choisir l'id du job"
  read idjob
  atrm $idjob

}

case $choix in
  1)  ajouterTacheSys;;
  2)  ajouterTacheUser;;
  3)  ajouterTacheAt;;
  4)  listTache;;
  5)  supprimerTache;;
esac
