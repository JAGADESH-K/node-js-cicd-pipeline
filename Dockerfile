# Use the specific SHA for Node 24-slim for better immutability
FROM node:24-slim@sha256:d3916757af2580a6d6d7616616422d3c50000a0684f52f534138e6e52295677c

# Patch OS vulnerabilities (dpkg, libcap2)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Use non-root user for better security (standard in Node images)
USER node
WORKDIR /home/node/app

# Copy dependency files first (better layer caching)
COPY --chown=node:node package*.json ./
RUN npm install --only=production

# Copy application code
COPY --chown=node:node app.js .

# Add Healthcheck to help the Target Group
# This hits your /health route every 30s
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000

CMD [ "node", "app.js" ]
