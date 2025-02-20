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

ARG NODE_AUTH_TOKEN
RUN echo "@ScrollAgency:registry=https://npm.pkg.github.com/" > .npmrc && \
    echo "//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}" >> .npmrc

RUN npm rebuild

# Installe les dépendances
RUN npm install
RUN npm cache clean --force


# Copie le reste des fichiers de l'application
COPY . .

# Installer Playwright et ses navigateurs
WORKDIR /app/tests
RUN npm install playwright

# Retour au répertoire principal de l'application
WORKDIR /app

# Exécuter le build de Next.js
RUN npm run build

# Expose le port que l'application utilise
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]
