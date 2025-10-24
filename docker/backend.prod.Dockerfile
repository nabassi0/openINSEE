FROM oven/bun:latest AS builder

WORKDIR /app

COPY package.json bun.lock tsconfig.base.json ./
COPY shared/shared ./shared/shared
COPY backend/backend ./backend/backend

ENV HUSKY=0
RUN bun install

# Copy source code
COPY shared ./shared
COPY backend ./backend

FROM builder AS backend-dev
WORKDIR /app/backend
EXPOSE 3000
CMD ["bun","run","dev"]