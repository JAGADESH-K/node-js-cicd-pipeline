# 1. Use 'slim' for a smaller, more secure footprint.
FROM node:24-alpine

# 2. Patch OS vulnerabilities found in ECR
RUN apk update && apk upgrade --no-cache

# 3. Set working directory
WORKDIR /usr/src/app

# 4. Copy package files first for better layer caching
COPY package*.json ./
RUN npm install --only=production

# 5. Copy your application code
COPY app.js .

# 6. Use a non-root user (security best practice)
USER node

EXPOSE 3000

CMD [ "node", "app.js" ]
