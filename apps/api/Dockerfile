FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
COPY apps/api/package.json ./apps/api/package.json
COPY apps/admin/package.json ./apps/admin/package.json
RUN npm ci --workspace apps/api
COPY apps/api/ ./apps/api/
RUN npm run build --workspace apps/api

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json ./
COPY apps/api/package.json ./apps/api/package.json
COPY apps/admin/package.json ./apps/admin/package.json
RUN npm ci --workspace apps/api --omit=dev
COPY --from=build /app/apps/api/dist ./apps/api/dist
CMD ["node", "apps/api/dist/main.js"]
