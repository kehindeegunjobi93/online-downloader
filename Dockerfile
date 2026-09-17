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
ENV WEB_DEFAULT_API="http://localhost:9000/"
RUN pnpm --filter=@imput/cobalt-web build

# Deploy API production bundle
RUN pnpm deploy --filter=@imput/cobalt-api --prod /prod/api

FROM base AS runner
WORKDIR /app

# Install Caddy for reverse-proxying API & Web on the single public PORT
USER root
RUN apk add --no-cache caddy

# Copy compiled API and Web artifacts
COPY --from=build /prod/api /app/api
COPY --from=build /app/web/build /app/web-build

# Startup script to run API backend and Web frontend behind Caddy reverse proxy
COPY <<'EOF' /app/start.sh
#!/bin/sh
export PORT="${PORT:-10000}"
export API_URL="${API_URL:-http://localhost:${PORT}/}"

# Write Caddyfile config
cat <<CADDY_EOF > /app/Caddyfile
:${PORT} {
    # Route /tunnel and POST / directly to API backend on 9000
    @api {
        path /tunnel* /session*
        method POST
    }
    handle @api {
        reverse_proxy 127.0.0.1:9000
    }
    handle {
        # Serve static Web UI
        file_server {
            root /app/web-build
        }
        try_files {path} /index.html
    }
}
CADDY_EOF

# Start API Backend on 9000
echo "Starting Cobalt API Backend on port 9000..."
cd /app/api && node src/cobalt &

# Start Caddy Reverse Proxy on PORT
echo "Starting Reverse Proxy on port ${PORT}..."
exec caddy run --config /app/Caddyfile --adapter caddyfile
EOF

RUN chmod +x /app/start.sh

EXPOSE 10000 9000
CMD ["/app/start.sh"]
