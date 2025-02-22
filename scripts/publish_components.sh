#!/bin/bash
git rm -r --cached .
clear
declare -g -A remote_versions
declare -g -A local_versions

# Fonction pour récupérer les versions des composants distants depuis la bibliothèque
fetch_remote_versions() {
  echo "Récupération des versions des composants distants depuis la bibliothèque..."

  # Cloner le dépôt distant dans un répertoire temporaire
  temp_dir=$(mktemp -d -p .)  # Créer le répertoire temporaire dans le dossier courant
  git clone git@github.com:ScrollAgency/plasmic-library.git "$temp_dir/plasmic-library"

 
  for dir in "$temp_dir"/plasmic-library/src/components/*/*/; do
    if [ -d "$dir" ]; then
      version_file="$dir/version"
      if [ -f "$version_file" ]; then
        component_name=$(basename "$dir")
        version=$(cat "$version_file")
        remote_versions["$component_name"]="$version"
      fi
    fi
  done

  rm -rf "$temp_dir"
}

# Fonction pour récupérer la liste des composants et leur version localement
fetch_local_versions() {
  echo ""
  echo "Récupération des versions des composants locaux..."
  echo ""

  for dir in plasmic-library/*/*/; do
    if [ -d "$dir" ]; then
      component_name=$(basename "$dir")
      version_file="$dir/version"
      if [ -f "$version_file" ]; then
        version=$(cat "$version_file")
        local_versions["$component_name"]="$version"
      fi
    fi
  done
}

# Nettoyer le readme
echo "" > README.MD

# Fonction pour afficher le tableau comparatif des versions
display_comparison_table() {
  {
    echo "## 📊 Comparaison des versions des composants"
    echo ""
    printf "| %-30s | %-20s | %-20s |\n" "Composant" "Version distante" "Version locale"
    echo "|--------------------------------|----------------------|----------------------|"

    for component in "${!remote_versions[@]}"; do
      remote_version="${remote_versions[$component]}"
      local_version="${local_versions[$component]:-N/A}"
      printf "| %-30s | %-20s | %-20s |\n" "$component" "$remote_version" "$local_version"
    done

    for component in "${!local_versions[@]}"; do
      if [[ -z "${remote_versions[$component]}" ]]; then
        local_version="${local_versions[$component]}"
        printf "| %-30s | %-20s | %-20s |\n" "$component" "N/A" "$local_version"
      fi
    done
    echo ""
  } | tee -a README.MD

}


# Fonction pour comparer les versions
compare_versions() {
  conflicts=()
  new_components=()
  updates=()

  # Comparaison des composants présents en distant
  for component in "${!remote_versions[@]}"; do
    remote_version="${remote_versions[$component]}"
    local_version="${local_versions[$component]}"

    if [[ -z "$local_version" ]]; then
      # Composant nouveau en distant, absent en local
      new_components+=("$component ($remote_version)")
    elif [[ -n "$local_version" && -n "$remote_version" ]]; then
      if [[ "$(printf '%s\n' "$local_version" "$remote_version" | sort -V | head -n1)" == "$local_version" && "$local_version" != "$remote_version" ]]; then
        conflicts+=("$component ($remote_version > $local_version)")
      elif [[ "$(printf '%s\n' "$remote_version" "$local_version" | sort -V | head -n1)" == "$remote_version" && "$local_version" != "$remote_version" ]]; then
        updates+=("$component ($local_version > $remote_version)")
      fi
    fi
  done

  # Vérifier les composants qui existent en local mais pas en distant
  for component in "${!local_versions[@]}"; do
    if [[ -z "${remote_versions[$component]}" ]]; then
      new_components+=("$component (${local_versions[$component]})") 
    fi
  done
}

declare -p remote_versions
declare -p local_versions


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
  fetch_remote_versions
  fetch_local_versions
  display_comparison_table
  compare_versions
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
read -p "Entrer le nom de la branch : " choix_branche
BRANCH_NAME="update-components-$choix_branche"

# Pousser la branche actuelle pour conserver les modifications
echo "🚀 Push de la branche library avant création d'une branche temporaire : $BRANCH_NAME"
git add .
git commit -m "$BRANCH_NAME"
git push origin local-gael

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

git checkout local-gael -- plasmic-library
git checkout local-gael -- README.MD

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
if [[ -n $(git ls-files --others --exclude-standard) || -n $(git status --porcelain) ]]; then

  echo "📝 Commit des modifications..."
  git commit -m "🚀 Mise à jour des composants dans le dossier plasmic-library"

  # Pousser la branche vers plasmic-library
  echo "🚀 Poussée de la branche de mise à jour vers plasmic-library..."
  git push plasmic-library "$BRANCH_NAME"

  git clean -fd
  git clean -fd
  git checkout local-gael
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