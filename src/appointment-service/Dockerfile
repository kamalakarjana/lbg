FROM node:18-alpine3.21

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

# Update Alpine packages to fix security vulnerabilities
RUN apk update && apk upgrade

COPY . .

EXPOSE 3001

USER node

CMD ["node", "appointment-service.js"]
