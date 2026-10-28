FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

FROM node:20-alpine
LABEL org.opencontainers.image.source="https://github.com/Taniyeah/L00205444-mini-pipeline"
WORKDIR /app
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY index.js package.json ./
USER node
EXPOSE 3000
CMD ["node", "index.js"]
