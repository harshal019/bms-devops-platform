# ---------- STAGE 1: Build the app ----------
FROM node:18 AS builder

WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Fix PostCSS compatibility issue
RUN npm install postcss@8.4.21 postcss-safe-parser@6.0.0 --legacy-peer-deps

# Install project dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build


# ---------- STAGE 2: NGINX ----------
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx config 
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]