# ---------- STAGE 1: Build the app ----------
FROM node:18 AS builder

WORKDIR /app

ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy dependency files
COPY bookmyshow-app/package*.json ./

# Fix PostCSS compatibility issue
RUN npm install postcss@8.4.21 postcss-safe-parser@6.0.0 --legacy-peer-deps

# Install project dependencies
RUN npm install

# Copy source code
COPY bookmyshow-app/ .

# Build the application
RUN npm run build


# ---------- STAGE 2: NGINX ----------
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx config 
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
