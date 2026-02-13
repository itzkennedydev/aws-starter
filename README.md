# AWS Starter

Production-ready Next.js template for deployment on AWS (ECS Fargate or S3 + CloudFront).

## Quick Start

```bash
bun install  # or npm install
bun dev      # or npm run dev
```

## Deployment Modes

### Fargate (SSR — has API routes or dynamic content)

1. `next.config.ts` → `output: "standalone"` (default)
2. Add site to `fargate_sites` in Terraform
3. `terraform apply`
4. Push to main → CodeBuild auto-deploys

### Static (S3 + CloudFront — no API routes)

1. `next.config.ts` → `output: "export"` + `images: { unoptimized: true }`
2. Add site to `static_sites` in Terraform
3. `terraform apply`
4. Push to main → CodeBuild builds, syncs to S3, invalidates CloudFront

## What's Included

- Next.js 15 + React 19 + TypeScript
- Tailwind CSS
- Sharp (optimized image processing)
- AVIF + WebP image formats
- Static robots.txt + sitemap.ts
- Production Dockerfile (multi-stage, ARM64)
- `.dockerignore` for fast Docker builds
