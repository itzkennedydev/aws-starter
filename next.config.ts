import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // For Fargate (Docker): use 'standalone'
  // For S3 + CloudFront (static): use 'export'
  output: "standalone",
  images: {
    formats: ["image/avif", "image/webp"],
  },
  reactStrictMode: true,
};

export default nextConfig;
