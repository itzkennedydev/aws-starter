# AWS Starter

Production-ready Next.js template for deployment on AWS (ECS Fargate or S3 + CloudFront).

## Tech Stack

| Tool | Purpose |
| --- | --- |
| Next.js 15 | Framework |
| React 19 | UI library |
| TypeScript | Language |
| Tailwind CSS | Styling |
| Sharp | Image optimization |
| Docker | Containerization |
| Terraform | Infrastructure as code |

## Quick Start

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

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

## Project Structure

```
aws-starter/
├── src/
│   ├── app/
│   │   ├── layout.tsx      # Root layout
│   │   ├── page.tsx         # Homepage
│   │   ├── robots.ts        # SEO robots config
│   │   └── sitemap.ts       # SEO sitemap generator
│   └── lib/
│       └── utils.ts         # Shared utilities
├── Dockerfile               # Multi-stage ARM64 build
├── next.config.ts           # Next.js config
├── tailwind.config.ts       # Tailwind config
└── tsconfig.json            # TypeScript config
```

## Scripts

| Command | Description |
| --- | --- |
| `npm run dev` | Start development server |
| `npm run build` | Production build |
| `npm start` | Start production server |
| `npm run lint` | Run ESLint |
| `npm run typecheck` | Run TypeScript checks |

## License

MIT
