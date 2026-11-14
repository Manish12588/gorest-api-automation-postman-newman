# Use the official Node.js 20 image as the base image
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /app

# Install Newman globally
RUN apk add --no-cache bash && npm install -g newman newman-reporter-htmlextra && npm cache clean --force

ENTRYPOINT ["newman"]