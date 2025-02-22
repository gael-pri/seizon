#!/bin/bash

echo ""
echo "🔍 Vérification du dossier plasmic-library..."

mkdir -p plasmic-library  # Crée le dossier s'il n'existe pas
if [ -z "$(ls -A plasmic-library 2>/dev/null)" ]; then
  echo "⚠️ Le dossier plasmic-library est vide. Téléchargement des composants..."
  
  git remote add plasmic-library git@github.com:ScrollAgency/plasmic-library.git 2>/dev/null || true
  git fetch plasmic-library
  git checkout plasmic-library/main -- src/components
  mv src/components/* plasmic-library/
  rm -r src/components src 2>/dev/null || true
  rm -f plasmic-library/index.ts
  
  echo ""
  echo "📦 Les composants ont été téléchargés et déplacés dans plasmic-library."
else
  echo "✅ Le dossier plasmic-library contient déjà des fichiers."
  echo "🔄 Analyse des différences avec la version distante..."
  echo ""

  git remote add plasmic-library git@github.com:ScrollAgency/plasmic-library.git 2>/dev/null || true
  git fetch plasmic-library
  git checkout plasmic-library/main -- src/components

  # Lister les nouveaux composants et ceux qui existent déjà
  new_components=()
  updated_components=()

  for dir in src/components/*/; do
    if [ -d "$dir" ]; then
      dirname=$(basename "$dir")

      for subdir in "$dir"/*/; do
        if [ -d "$subdir" ]; then
          subdirname=$(basename "$subdir")
          component="$dirname/$subdirname"

          if [ -d "plasmic-library/$component" ]; then
            updated_components+=("$component")  # Composant existant à mettre à jour
          else
            new_components+=("$component")  # Nouveau composant
          fi
        fi
      done
    fi
  done

  # Fonction pour afficher les composants sous forme groupée
  display_grouped_components() {
    declare -A component_groups

    for component in "${@}"; do
      parent_dir=$(dirname "$component")
      component_name=$(basename "$component")
      
      if [[ -z "${component_groups[$parent_dir]}" ]]; then
        component_groups[$parent_dir]="$component_name"
      else
        component_groups[$parent_dir]="${component_groups[$parent_dir]} / $component_name"
      fi
    done

    for parent in "${!component_groups[@]}"; do
      count=$(echo "${component_groups[$parent]}" | awk -F' / ' '{print NF}')
      echo "- $parent ($count) -> ${component_groups[$parent]}"
    done
  }

  # Affichage des composants
  if [ ${#updated_components[@]} -gt 0 ]; then
    echo ""
    echo "🔄 Composants existants qui seront mis à jour :"
    display_grouped_components "${updated_components[@]}"
  fi

  if [ ${#new_components[@]} -gt 0 ]; then
    echo ""
    echo "🛠️ Nouveaux composants à ajouter :"
    display_grouped_components "${new_components[@]}"
  fi

  # Demander l'action à l'utilisateur
  echo ""
  echo "💬 Que souhaitez-vous faire ?"
  echo ""
  echo "1 - Ajouter uniquement les nouveaux composants"
  echo "2 - Ajouter les nouveaux composants et mettre à jour ceux existants"
  echo ""
  read -p "Entrez votre choix (1 ou 2) : " choix
  echo ""

  if [ "$choix" == "1" ]; then
    echo "🛠️ Ajout des nouveaux composants uniquement..."
  elif [ "$choix" == "2" ]; then
    echo "🔄 Suppression des composants existants avant mise à jour..."
    
    # Supprimer les anciens composants à mettre à jour
    for component in "${updated_components[@]}"; do
      if [ -d "plasmic-library/$component" ]; then
        rm -rf "plasmic-library/$component"  # Suppression propre
      fi
    done
    echo "🗑️ Anciennes versions supprimées."
  else
    echo "❌ Option invalide. Aucune action effectuée."
    rm -r src/components src 2>/dev/null || true
    exit 1
  fi

  # Ajouter tous les nouveaux composants et ceux mis à jour
  for component in "${new_components[@]}" "${updated_components[@]}"; do
    subdir_path=$(dirname "$component")
    mkdir -p "plasmic-library/$subdir_path"  # Créer la structure de dossiers
    cp -r "src/components/$component" "plasmic-library/$subdir_path/"  # Copier les fichiers
  done

  echo ""
  echo "✅ Tous les composants ont été mis à jour avec succès."

  # Nettoyage des fichiers temporaires
  rm -r src/components src 2>/dev/null || true
  rm -f plasmic-library/index.ts
fi
