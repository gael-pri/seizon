# Utilise une image de base (ex. Node.js pour une application Node)
FROM node:20-alpine

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