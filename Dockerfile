# Use the official Node.js Alpine image as the base image
FROM node:18-alpine

# Set the working directory
WORKDIR /usr/src/app

# Install Chromium
ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    NODE_ENV="production"
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    udev \
    ttf-freefont \
    chromium

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the source code to the working directory
COPY . .

# Rebuild the lock file if necessary
RUN npm install --package-lock-only

# Install dependencies using npm ci to ensure a clean environment
RUN npm ci --only=production --ignore-scripts

# Expose the port the API will run on
EXPOSE 3000

# Start the API
CMD ["npm", "start"]
