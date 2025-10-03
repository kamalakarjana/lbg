FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY appointment-service.js .
EXPOSE 3001
USER node
CMD ["node", "appointment-service.js"]
