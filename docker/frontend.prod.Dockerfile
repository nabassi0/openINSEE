# Build stage
FROM node:20-alpine AS builder

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy workspace files
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml tsconfig.base.json ./
COPY shared/package.json shared/tsconfig.json ./shared/
COPY frontend/package.json frontend/tsconfig.json frontend/tsconfig.node.json ./frontend/

# Install dependencies
ENV HUSKY=0
RUN pnpm install --frozen-lockfile

# Copy source code
COPY shared/src ./shared/src
COPY frontend/src ./frontend/src
COPY frontend/index.html ./frontend/
COPY frontend/vite.config.ts ./frontend/

# Build frontend
WORKDIR /app/frontend
RUN pnpm run build

# Production stage - serve with nginx
FROM nginx:alpine

# Copy built files
COPY --from=builder /app/frontend/dist /usr/share/nginx/html

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
