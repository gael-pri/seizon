const JamButtonMeta = {
    name: "JamButton",
    section: "Scroll Jam",
    displayName: "Jam Button",
    description: "Button used in Job Around Me project",
    thumbnailUrl: "https://static1.plasmic.app/insertables/button.svg",
    props: {
      label: {
        type: "string",
        description: "The text to display inside the button.",
        defaultValue: "Button",
      },
      icon: {
        type: "string",
        description: "Position of the icon: 'start', 'end', 'only', or 'none'.",
        options: ["start", "end", "only", "none"],
        defaultValue: "none",
      },
      destructive: {
        type: "boolean",
        description: "If true, the button will have a destructive style.",
        defaultValue: false,
      },
      hierarchy: {
        type: "string",
        description: "The hierarchy level of the button: 'primary' or 'secondary'.",
        options: ["primary", "secondary"],
        defaultValue: "primary",
      },
      size: {
        type: "string",
        description: "The size of the button: 'small' or 'large'.",
        options: ["small", "large"],
        defaultValue: "large",
      },
      state: {
        type: "string",
        description: "The state of the button: 'default', 'hover', 'focused', or 'disabled'.",
        options: ["default", "hover", "focused", "disabled"],
        defaultValue: "default",
      },
      iconImage: {
        type: "string",
        description: "The URL of the icon image to display.",
      },
      className: {
        type: "string",
        description: "Additional CSS classes to apply to the button.",
      },
      disabled: {
        type: "boolean",
        description: "If true, the button will be disabled.",
        defaultValue: false,
      },
      onClick: {
        type: "function",
        description: "Callback function to handle button click events.",
      },
    },
    importPath: "./components/forms/JamButton/JamButton",
  };
  
  export { JamButtonMeta };
  