# Utilise une image de base (ex. Node.js pour une application Node)
FROM node:20-alpine

# Définir des arguments de build
ARG NEXT_PUBLIC_PLASMIC_PROJECT_ID
ARG NEXT_PUBLIC_PLASMIC_PROJECT_TOKEN

# Utiliser les arguments de build comme variables d'environnement
ENV NEXT_PUBLIC_PLASMIC_PROJECT_ID=${NEXT_PUBLIC_PLASMIC_PROJECT_ID}
ENV NEXT_PUBLIC_PLASMIC_PROJECT_TOKEN=${NEXT_PUBLIC_PLASMIC_PROJECT_TOKEN}

# Répertoire de travail pour l'app
WORKDIR /app

# Copie les fichiers nécessaires dans l'image
COPY package.json package-lock.json ./

# Installe les dépendances
RUN npm install

# Copie le reste des fichiers de l'application
COPY . .
RUN npm run build

# Expose le port que l'application utilise
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]