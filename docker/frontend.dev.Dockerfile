FROM oven/bun:latest AS builder

WORKDIR /app

COPY package.json bun.lock tsconfig.base.json ./
# copy files into explicit paths so we don't create a file named './shared' or './frontend'
COPY shared/package.json ./shared/package.json
COPY shared/bun.lock ./shared/bun.lock
COPY frontend/package.json ./frontend/package.json
COPY frontend/bun.lock ./frontend/bun.lock

ENV HUSKY=0
RUN bun install

# Copy source code
COPY shared ./shared
COPY frontend ./frontend

FROM builder AS frontend-dev
WORKDIR /app/frontend
EXPOSE 5173
CMD ["bun","run","dev"]