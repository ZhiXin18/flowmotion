#
# Flowmotion
# Backend
# Dockerfile
#

FROM node:20.18.0-slim AS base
WORKDIR /app
RUN chown node /app
USER node
ADD https://raw.githubusercontent.com/ZhiXin18/flowmotion/refs/heads/master/schema/flowmotion_api.yaml /app/
# Install dependencies 
COPY --chown=node:node package*.json ./
RUN npm ci --omit=dev

FROM base as build
# Install build dependencies 
RUN npm ci
# Copy source code
COPY --chown=node:node . .
# Transpile Typescript
RUN npm run build

FROM base as production
# Set NODE_ENV to production by default
ENV NODE_ENV=production
COPY --from=build /app/dist /app/
CMD ["node", "index.js", "flowmotion_api.yaml", "3000"]
