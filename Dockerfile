# =============================================
# Production Next.js Dockerfile (ARM64 + Standalone)
# =============================================
# Optimized for ECS Fargate Spot deployment.
# Multi-stage build keeps the final image small.
# =============================================

FROM public.ecr.aws/docker/library/node:20-slim AS deps
WORKDIR /app
RUN apt-get update -y && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

COPY package*.json bun.lockb* yarn.lock* pnpm-lock.yaml* ./
COPY prisma ./prisma/ 2>/dev/null || true

RUN if [ -f bun.lockb ]; then \
      npm install -g bun && bun install; \
    elif [ -f pnpm-lock.yaml ]; then \
      npm install -g pnpm && pnpm install; \
    elif [ -f yarn.lock ]; then \
      yarn install --frozen-lockfile; \
    else \
      npm ci || npm install; \
    fi

FROM public.ecr.aws/docker/library/node:20-slim AS builder
WORKDIR /app
RUN apt-get update -y && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1
ENV SKIP_ENV_VALIDATION=1

# Load build-time env vars if present (.env.build from CodeBuild)
RUN if [ -f .env.build ]; then cp .env.build .env.local; fi && \
    if [ -f .env.local ]; then set -a && . ./.env.local && set +a; fi && \
    npm run build

FROM public.ecr.aws/docker/library/node:20-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN apt-get update -y && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*
RUN groupadd --system --gid 1001 nodejs && useradd --system --uid 1001 nextjs

# Copy standalone output
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
