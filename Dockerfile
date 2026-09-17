# Unified Dockerfile for Cobalt API + Web UI on Koyeb / Docker platforms
FROM node:24-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base AS build
WORKDIR /app
COPY . /app

RUN apk add --no-cache python3 alpine-sdk
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --frozen-lockfile

# Build web frontend
RUN pnpm --filter=@imput/cobalt-web build

# Deploy API production bundle
RUN pnpm deploy --filter=@imput/cobalt-api --prod /prod/api

FROM base AS runner
WORKDIR /app

# Install static file server for web
RUN npm install -g serve

# Copy compiled API and Web artifacts
COPY --from=build --chown=node:node /prod/api /app/api
COPY --from=build --chown=node:node /app/web/build /app/web-build
COPY --from=build --chown=node:node /app/.git /app/api/.git

# Startup script to run API backend and Web frontend simultaneously
COPY --chown=node:node <<'EOF' /app/start.sh
#!/bin/sh
# Serve Web UI on PORT (default 7575 for Koyeb)
echo "Starting Cobalt Web UI..."
npx serve -s /app/web-build -l ${PORT:-7575} &

# Start API Backend on 9000
echo "Starting Cobalt API Backend..."
cd /app/api && exec node src/cobalt
EOF

RUN chmod +x /app/start.sh

USER node

EXPOSE 7575 9000
CMD ["/app/start.sh"]
