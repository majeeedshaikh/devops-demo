# multi-arch base image
FROM --platform=${BUILDPLATFORM} node:18-alpine

# set workdir & install prod deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# copy app & add healthcheck
COPY . .
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:8080/health || exit 1

# expose both the HTTP and metrics ports
EXPOSE 8080
EXPOSE 9091

# start server
CMD ["node", "index.js"]
