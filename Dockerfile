# -------- Stage 1: Build React App --------
FROM node:18 AS build

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build React app
RUN npm run build


# -------- Stage 2: Serve using Nginx --------
FROM nginx:alpine

# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy React build files
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]