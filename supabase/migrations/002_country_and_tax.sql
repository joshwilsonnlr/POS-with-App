CREATE TABLE IF NOT EXISTS public.business_country_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE UNIQUE,
  country_code text NOT NULL,
  country_name text NOT NULL,
  currency_code text NOT NULL,
  currency_precision integer NOT NULL DEFAULT 2 CHECK (currency_precision >= 0),
  timezone text NOT NULL,
  language_code text NOT NULL,
  date_format text NOT NULL DEFAULT 'YYYY-MM-DD',
  number_format text NOT NULL DEFAULT '#,##0.00',
  tax_registration_number text,
  address_line1 text,
  address_line2 text,
  city text,
  region text,
  postal_code text,
  is_cash_on_delivery_enabled boolean NOT NULL DEFAULT true,
  enabled_payment_providers text[] NOT NULL DEFAULT '{}',
  settings jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.tax_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  name text NOT NULL,
  country_code text NOT NULL,
  default_tax_rule_id uuid,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.tax_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tax_profile_id uuid NOT NULL REFERENCES public.tax_profiles(id) ON DELETE CASCADE,
  name text NOT NULL,
  rate_bps integer NOT NULL CHECK (rate_bps >= 0 AND rate_bps <= 100000),
  tax_type text NOT NULL CHECK (tax_type IN ('vat', 'sales', 'service', 'other')),
  pricing_mode text NOT NULL CHECK (pricing_mode IN ('inclusive', 'exclusive')),
  applies_to text[] NOT NULL DEFAULT '{}',
  branch_ids uuid[] NOT NULL DEFAULT '{}',
  effective_from timestamptz NOT NULL DEFAULT now(),
  effective_to timestamptz,
  rounding_rule text NOT NULL DEFAULT 'half_up',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_tax_profiles_business_id ON public.tax_profiles(business_id);
CREATE INDEX IF NOT EXISTS idx_tax_rules_tax_profile_id ON public.tax_rules(tax_profile_id);
