#!/bin/bash

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

# Préparer les fichiers de versions
REMOTE_VERSIONS_FILE=$(mktemp)
LOCAL_VERSIONS_FILE=$(mktemp)

declare -A remote_versions
declare -A local_versions

fetch_remote_versions
fetch_local_versions

for component in "${!remote_versions[@]}"; do
  echo "$component ${remote_versions[$component]}" >> "$REMOTE_VERSIONS_FILE"
done

for component in "${!local_versions[@]}"; do
  echo "$component ${local_versions[$component]}" >> "$LOCAL_VERSIONS_FILE"
done

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

display_comparison_table
compare_versions

# Fonction pour afficher les résultats
display_results() {
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

  if [ ${#conflicts[@]} -eq 0 ] && [ ${#new_components[@]} -eq 0 ] && [ ${#updates[@]} -eq 0 ]; then
    echo "" | tee -a README.MD
    echo "✅ Les versions locales de vos composants sont à jour !" | tee -a README.MD
    echo ""
  fi
}

display_results
