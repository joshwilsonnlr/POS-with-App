import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'POS with App',
  description: 'International multi-tenant restaurant SaaS foundation',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
