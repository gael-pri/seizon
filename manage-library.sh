#!/bin/bash
clear

# Afficher le menu principal
echo "         Librairie Plasmic "
echo "         ----------------- "
echo "💬 Veuillez choisir une action :"
echo ""
echo "1 - Comparer les composants locaux et distants"
echo "2 - Télécharger le dossier des composants"
echo "3 - Publier vos composants vers la bibliothèque"
echo ""
read -p "Entrez le numéro de l'action souhaitée : " action

# Exécuter l'action choisie
case $action in
  1)
    ./scripts/compare_components.sh
    ;;
  2)
    ./scripts/download_update.sh
    ;;
  3)
    ./scripts/publish_components.sh  #
    ;;
  *)
    echo "❌ Action invalide. Veuillez entrer 1 ou 2."
    ;;
esac
