# Stage 1: Builder
FROM node:22 AS builder

WORKDIR /app

COPY app/package.json .
COPY app/server.js .

RUN npm run build


# Stage 2: Runtime
FROM node:22-slim

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json .

EXPOSE 3000

CMD ["npm", "start"]
