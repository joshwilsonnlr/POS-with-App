CREATE TABLE IF NOT EXISTS public.payment_provider_configs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  provider_name text NOT NULL CHECK (
    provider_name IN ('stripe', 'paypal', 'adyen', 'local_gateway')
  ),
  status text NOT NULL DEFAULT 'disabled'
    CHECK (status IN ('disabled', 'sandbox', 'enabled', 'rejected')),
  mode text NOT NULL DEFAULT 'test'
    CHECK (mode IN ('test', 'live')),
  config jsonb NOT NULL DEFAULT '{}'::jsonb,
  webhook_secret text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (business_id, provider_name)
);

CREATE TABLE IF NOT EXISTS public.subscription_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  price_minor integer NOT NULL DEFAULT 0,
  currency_code text NOT NULL DEFAULT 'USD',
  interval text NOT NULL CHECK (interval IN ('month', 'year')),
  features jsonb NOT NULL DEFAULT '{}'::jsonb,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  plan_id uuid NOT NULL REFERENCES public.subscription_plans(id),
  status text NOT NULL CHECK (
    status IN ('trial', 'active', 'past_due', 'paused', 'cancelled', 'expired')
  ),
  billing_interval text NOT NULL CHECK (billing_interval IN ('month', 'year')),
  current_period_start timestamptz NOT NULL DEFAULT now(),
  current_period_end timestamptz,
  trial_ends_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (business_id, status)
);

CREATE INDEX IF NOT EXISTS idx_payment_provider_configs_business_id ON public.payment_provider_configs(business_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_business_id ON public.subscriptions(business_id);
