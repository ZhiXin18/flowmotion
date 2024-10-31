#
# Flowmotion
# Backend
# Dockerfile
#

FROM node:20.18.0-slim AS base
WORKDIR /app
ADD https://raw.githubusercontent.com/ZhiXin18/flowmotion/refs/heads/master/schema/flowmotion_api.yaml /app/
RUN chown -R node /app
USER node
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
# copy geocoding data
COPY --from=build /app/data /app/data
CMD ["node", "index.js", "flowmotion_api.yaml", "3000"]
