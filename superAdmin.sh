#!/bin/bash



clear;
echo "[1] Gestion d'utilisateurs"
echo "[2] Gestion des tâches planifiés"
echo "[3] Gesiton des Logs"
echo "[4] Gestion du réseaux"
echo "[5] Quitter"

echo "Faites votre choix : "
read choix

case $choix in
  1) echo -e "Gestion d'utilisateurs...";
    ./userman.sh;;
  2) echo -e "Gestion des tâches ...";;
  3) echo -e "La journalisation ...";;
  4) echo -e "Gestion du réseaux ...";;
  *) echo -e "Ce choix n'existe pas !";;
esac
