# AWS Starter

Next.js template for deploying on AWS, wired for two modes: server-rendered on ECS Fargate, or fully static on S3 + CloudFront. Terraform and a multi-stage ARM64 Dockerfile are included.

## Local development

```bash
npm install
npm run dev
```

## Deploying

**Fargate (SSR, API routes):** keep `output: "standalone"` in `next.config.ts`, add the site to `fargate_sites` in Terraform, run `terraform apply`, and push to main. CodeBuild deploys it.

**Static (no API routes):** switch `next.config.ts` to `output: "export"` with `images: { unoptimized: true }`, add the site to `static_sites`, run `terraform apply`, and push to main. CodeBuild syncs to S3 and invalidates CloudFront.
