const DropdownMeta = {
  name: "Dropdown",
  section: "Scroll Test",
  displayName: "Dropdown",
  description: "Description de cette belle carte",
  thumbnailUrl: "https://static1.plasmic.app/insertables/select.svg",
  props: {
    showLabel: {
      type: "boolean",
      defaultValue: true,
      description: "Affiche ou masque l'étiquette du dropdown.",
    },
    label: {
      type: "string",
      defaultValue: "Dropdown",
      description: "Texte de l'étiquette du dropdown.",
    },
    type: {
      type: "choice",
      options: ["default", "icon", "avatar", "dot", "search"],
      defaultValue: "default",
      description: "Définit le type d'affichage des options dans le dropdown.",
    },
    state: {
      type: "choice",
      options: ["placeholder", "hover", "default", "focused", "disabled"],
      defaultValue: "default",
      description: "État visuel du dropdown.",
    },
    check: {
      type: "boolean",
      defaultValue: false,
      description: "Affiche une icône de validation pour l'option sélectionnée.",
    },
    options: {
      type: "array",
      description: "Liste des options disponibles dans le dropdown.",
      itemProps: {
        id: {
          type: "string",
          description: "Identifiant unique de l'option.",
        },
        label: {
          type: "string",
          description: "Libellé de l'option.",
        },
        icon: {
          type: "string",
          description: "Chemin de l'icône de l'option (si type = 'icon').",
        },
        avatar: {
          type: "string",
          description: "Chemin de l'avatar de l'option (si type = 'avatar').",
        },
        dotColor: {
          type: "string",
          description: "Couleur du point pour l'option (si type = 'dot').",
        },
      },
    },
    onChange: {
      type: "eventHandler",
      description: "Fonction appelée lors du changement de la case.",
      argTypes: [
        {
          name: "checked",
          type: "boolean",
        },
      ],
    },
  },
  importPath: "./components/forms/Dropdown/Dropdown",
};

export {DropdownMeta};