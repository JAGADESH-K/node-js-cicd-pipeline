# Use official Node.js light image
FROM node:20-slim

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
