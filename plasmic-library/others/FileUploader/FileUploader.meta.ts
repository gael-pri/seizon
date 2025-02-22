const FileUploaderMeta = {
    name: "FileUploader",
    section: "Scroll Test",
    displayName: "File uploader",
    description: "Description de cette belle carte",
    thumbnailUrl: "https://static1.plasmic.app/insertables/dataFetcher.svg",
    props: {
      state: {
        type: "choice",
        options: ["default", "hover", "uploading", "failed", "complete", "disabled"],
        defaultValue: "default",
        description: "État visuel du composant de téléchargement de fichiers.",
      },
      onFileSelect: {
        type: "eventHandler",  // Définir le type comme eventHandler
        description: "Fonction appelée lorsque le fichier est sélectionné.",
        argTypes: [
          {
            name: "file",  // Le nom de l'argument
            type: "file",  // Type de l'argument, ici un fichier
          },
        ],
      },
      accept: {
        type: "string",
        defaultValue: "*/*",
        description: "Filtre des types de fichiers acceptés. Par défaut, tous les fichiers sont autorisés.",
      },
      maxSize: {
        type: "number",
        defaultValue: 5242880, // 5MB
        description: "Taille maximale autorisée pour le fichier téléchargé en octets.",
      },
    },
    importPath: "./components/others/FileUploader/FileUploader",
  };
  
  export {FileUploaderMeta};
