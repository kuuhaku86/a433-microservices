# Use the official Node.js 18 image built on Alpine Linux for a lightweight footprint
FROM node:18-alpine

# Set the working directory inside the container where the application code will reside
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first
# This allows Docker to cache the 'npm install' layer if dependencies haven't changed
COPY package*.json ./

# Install only production dependencies to keep the image size small and reduce attack surface
RUN npm install --production

# Copy the rest of the application source code into the container
COPY . .

# Document that the service listens on port 3001
EXPOSE 3001

# Start the application using the command defined in the "start" script of package.json
CMD ["npm", "start"]
