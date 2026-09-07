FROM node:22-alpine

WORKDIR /app

COPY app/package.json .

RUN npm install

COPY app/ .

EXPOSE 3000

USER node 

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:3000/health',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))"

CMD ["npm", "start"]

