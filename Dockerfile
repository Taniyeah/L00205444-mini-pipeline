FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

FROM node:20-alpine
LABEL org.opencontainers.image.source="https://github.com/Taniyeah/L00205444-mini-pipeline"
WORKDIR /app
ENV NODE_ENV=production
# npm is not needed to run the app. Removing it also removes its bundled
# "tar" 6.2.1 (CVE-2026-59873, found by Trivy) and makes the image smaller.
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
COPY --from=deps /app/node_modules ./node_modules
COPY index.js package.json ./
USER node
EXPOSE 3000
CMD ["node", "index.js"]
