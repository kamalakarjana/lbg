FROM node:14-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

COPY patient-service.js .

EXPOSE 3000

USER node

CMD ["npm", "start"]