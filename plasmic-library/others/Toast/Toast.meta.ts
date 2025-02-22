const ToastMeta = {
  name: "Toast",
  section: "Scroll Test",
  displayName: "Toast",
  description: "Description de cette belle carte",
  thumbnailUrl: "https://static1.plasmic.app/insertables/text.svg",
  props: {
    badge: {
      type: "string",
      description: "Texte optionnel à afficher sous forme de badge.",
    },
    icon: {
      type: "string",
      description: "URL de l'icône à afficher à gauche du message.",
    },
    size: {
      type: "choice",
      options: ["small", "medium", "large"],
      defaultValue: "medium",
      description: "Taille du toast.",
    },
    color: {
      type: "choice",
      options: ["success", "error", "warning", "info"],
      defaultValue: "info",
      description: "Couleur du toast, qui influence le fond et le texte.",
    },
    message: {
      type: "string",
      required: true,
      description: "Message principal affiché dans le toast.",
    },
    onClose: {
      type: "function",  // Type de l'événement est une fonction
      description: "Fonction de fermeture du toast, appelée lors du clic sur l'icône de fermeture.",
      argTypes: [
        {
          name: "event",  // Le nom de l'argument
          type: "object",  // Type de l'argument
        },
      ],
    },
    autoClose: {
      type: "boolean",
      defaultValue: true,
      description: "Si `true`, le toast se ferme automatiquement après un certain délai.",
    },
    autoCloseDelay: {
      type: "number",
      defaultValue: 5000,
      description: "Délai (en millisecondes) avant que le toast ne se ferme automatiquement.",
    },
  },
  importPath: "./components/others/Toast/Toast",
};

export {ToastMeta};