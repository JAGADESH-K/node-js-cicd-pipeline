# Use official Node.js light image
FROM node:24-slim

# Fix: Update OS packages to patch vulnerabilities like dpkg and libcap2
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy local code to the container
COPY app.js .

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD [ "node", "app.js" ]
