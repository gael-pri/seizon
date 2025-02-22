const TestInputMeta = {
  name: "TestInput",
  section: "Scroll components",
  displayName: "Test input",
  description: "Description de cette belle carte",
  thumbnailUrl: "https://static1.plasmic.app/insertables/text-input.svg",
  props: {
    className: {
      type: "string",
      defaultValue: "", // Classe CSS par défaut
    },
    containerClassName: {
      type: "string",
      defaultValue: "", // Classe CSS pour le conteneur
    },
    inputClassName: {
      type: "string",
      defaultValue: "", // Classe CSS pour l'input
    },
    defaultValue: {
      type: "string",
      defaultValue: "", // Valeur par défaut pour le champ
    },
    onChange: {
      type: "eventHandler",
      argTypes: [{ name: "value", type: "string" }],
    },
  },
  importPath: "./components/others/TestInput/TestInput",
};

export default TestInputMeta;