#!/bin/bash
git rm -r --cached .
clear

# Appeler le script de comparaison pour obtenir les résultats
./scripts/compare_components.sh

# Fonction pour afficher les résultats
display_results() {
  echo ""
  echo "" | tee -a README.MD
  echo "📍 Résultats de la comparaison :" | tee -a README.MD

  if [ ${#conflicts[@]} -gt 0 ]; then
    echo "" | tee -a README.MD
    echo "⚠️ Conflits (version distante > version locale) :" | tee -a README.MD
    for conflict in "${conflicts[@]}"; do
      echo "- $conflict" | tee -a README.MD
    done
  fi

  if [ ${#new_components[@]} -gt 0 ]; then
    echo "" | tee -a README.MD
    echo "🛠️  Nouveaux composants (locaux mais absents en distant) :" | tee -a README.MD
    for new_component in "${new_components[@]}"; do
      echo "- $new_component" | tee -a README.MD
    done
  fi

  if [ ${#updates[@]} -gt 0 ]; then
    echo "" | tee -a README.MD
    echo "🔄 Mises à jour (version locale > version distante) :" | tee -a README.MD
    for update in "${updates[@]}"; do
      echo "- $update" | tee -a README.MD
    done
  fi
}

# Fonction pour publier les composants vers la bibliothèque
publish_components() {
  display_results

  echo ""
  echo "💬 Voulez-vous publier les composants (nouveaux et mis à jour) ?"
  echo "   1 - Oui"
  echo "   2 - Non"
  read -p "Entrez votre choix (1 ou 2) : " choix
  echo ""

  if [ "$choix" == "1" ]; then
    echo "📤 Publication des composants..."

    # Aller dans le dossier du repo plasmic-library
    cd plasmic-library || { echo "❌ Erreur : Impossible d'accéder à plasmic-library"; exit 1; }

    # Vérifier si la branche main existe dans le remote plasmic-library
    if ! git ls-remote --exit-code --heads plasmic-library main >/dev/null; then
      echo "❌ Erreur : La branche 'main' n'existe pas sur 'plasmic-library'."
      cd ..
      return
    fi

    # Vérifier s'il y a des composants à publier
    if [[ ${#new_components[@]} -eq 0 && ${#updates[@]} -eq 0 ]]; then
      echo "✅ Aucun nouveau composant ni mise à jour à publier."
      cd ..
      return
    fi

    cd ..

    # Sauvegarde de la branche actuelle
    echo ""
    read -p "Entrer le nom de la branche : " choix_branche
    BRANCH_NAME="update-components-$choix_branche"

    # Pousser la branche actuelle pour conserver les modifications
    echo "🚀 Push de la branche library avant création d'une branche temporaire : $BRANCH_NAME"
    git add .
    git commit -m "$BRANCH_NAME"
    git push origin library

    # Création d'une branche temporaire pour la mise à jour
    echo "🚀 Création d'une branche temporaire : $BRANCH_NAME"
    git fetch plasmic-library
    git checkout plasmic-library/main
    git pull
    git checkout -b "$BRANCH_NAME"

    # Vérifier si README.MD existe avant de le copier
    if [ -f "README.MD" ]; then
      cp README.MD old-readme.MD
    else
      echo "❌ Erreur : README.MD introuvable."
      exit 1
    fi

    # S'assurer que tout est bien suivi par Git
    git add .

    git checkout library -- plasmic-library
    git checkout library -- README.MD

    # Supprimer tout du suivi, sauf src/components
    echo "🧹 Suppression des fichiers du suivi Git"
    git rm -r --cached --ignore-unmatch node_modules

    # Réorganisation du dossier des composants
    echo "♻️ Réorganisation du dossier des composants"
    cp src/components/index.ts plasmic-library
    rm -rf src/components/*
    cp -r plasmic-library/* src/components/

    # ne pas suivre plasmic-library
    git rm -r --cached plasmic-library

    # Ajouter uniquement le contenu de plasmic-library
    echo "📥 Ajout des fichiers du dossier plasmic-library..."
    git add src/components/
    git add README.MD

    # Vérifier si des fichiers ont été ajoutés
    if [[ -n $(git status --porcelain) ]]; then
      echo "📝 Commit des modifications..."
      git commit -m "🚀 Mise à jour des composants dans le dossier plasmic-library"

      # Pousser la branche vers plasmic-library
      echo "🚀 Poussée de la branche de mise à jour vers plasmic-library..."
      git push plasmic-library "$BRANCH_NAME"

      git clean -fd
      git clean -fd
      git checkout library
      git branch -D "$BRANCH_NAME"

      clear
      echo ""
      echo "🔥 Branche poussée ! Vos composants sont prêt à être intégrés à la librairie Plasmic"
      echo ""
    else
      echo "✅ Aucun fichier dans plasmic-library à publier."
    fi

    # Revenir au dossier initial
    cd ..

  else
    echo "❌ Aucune publication effectuée."
  fi
}

# Appel de la fonction de publication
publish_components
