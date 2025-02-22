const ProgressBarMeta = {
  name: "ProgressBar",
  section: "Scroll Test",
  displayName: "Progress bar",
  description: "Description de cette belle carte",
  thumbnailUrl: "https://static1.plasmic.app/insertables/slider.svg",
  props: {
    label: {
      type: "string",
      description: "Libellé optionnel affiché au-dessus de la barre de progression.",
    },
    progress: {
      type: "number",
      required: true,
      description: "Valeur numérique représentant la progression, de 0 à 100.",
    },
    showPercentage: {
      type: "boolean",
      defaultValue: true,
      description: "Indique si le pourcentage de progression doit être affiché.",
    },
    color: {
      type: "choice",
      options: ["blue", "green", "red", "yellow"],
      defaultValue: "blue",
      description: "Couleur de la barre de progression.",
    },
    size: {
      type: "choice",
      options: ["small", "medium", "large"],
      defaultValue: "medium",
      description: "Taille de la barre de progression.",
    },
  },
  importPath: "./components/others/ProgressBar/ProgressBar",
};

export {ProgressBarMeta};