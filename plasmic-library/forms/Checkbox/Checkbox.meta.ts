const CheckboxMeta = {
    name: "Checkbox",
    section: "Scroll Test",
    displayName: "Checkbox",
    description: "Description de cette belle carte",
    thumbnailUrl: "https://static1.plasmic.app/insertables/checkbox.svg",
    props: {
      checked: {
        type: "boolean",
        defaultValue: false,
        description: "Détermine si la case est cochée.",
      },
      disabled: {
        type: "boolean",
        defaultValue: false,
        description: "Désactive la case à cocher si défini à vrai.",
      },
      state: {
        type: "choice",
        options: ["default", "focused", "disabled"],
        defaultValue: "default",
        description: "État visuel de la case à cocher.",
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
      label: {
        type: "string",
        description: "Texte affiché à côté de la case.",
      },
    },
    importPath: "./components/forms/Checkbox/Checkbox",
  };
  
export {CheckboxMeta};