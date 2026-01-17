FROM node:18-alpine

WORKDIR /app

COPY package*.json ./ 

RUN npm ci --only=production 

COPY server.js ./ 

EXPOSE 3000

RUN apk add --no-cache wget 

RUN apk add --no-cache curl 

RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001 

RUN chown -R nodejs:nodejs /app 

USER nodejs 

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:3000/health || exit 1

CMD ["node", "server.js"]
