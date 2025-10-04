FROM node:14-alpine

WORKDIR /app


COPY package*.json ./
RUN npm install --only=production

COPY appointment-service.js .

EXPOSE 3001

USER node

CMD ["npm", "start"]