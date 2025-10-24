FROM oven/bun:latest AS builder

WORKDIR /app

COPY package.json bun.lock tsconfig.base.json ./
# copy files into explicit paths so we don't create a file named './shared' or './backend'
COPY shared/package.json ./shared/package.json
COPY shared/bun.lock ./shared/bun.lock
COPY backend/package.json ./backend/package.json
COPY backend/bun.lock ./backend/bun.lock

ENV HUSKY=0
RUN bun install

# Copy source code
COPY shared ./shared
COPY backend ./backend

FROM builder AS backend-dev
WORKDIR /app/backend
EXPOSE 3000
CMD ["bun","run","dev"]