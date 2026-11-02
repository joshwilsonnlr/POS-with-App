INSERT INTO public.businesses (id, name, slug, status)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Demo Restaurant',
  'demo-restaurant',
  'active'
);

INSERT INTO public.profiles (id, full_name, email, is_platform_admin)
VALUES (
  '22222222-2222-2222-2222-222222222222',
  'Restaurant Owner',
  'owner@example.com',
  false
);

INSERT INTO public.business_members (business_id, user_id, role, status)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  '22222222-2222-2222-2222-222222222222',
  'owner',
  'active'
);

INSERT INTO public.business_country_settings (
  business_id,
  country_code,
  country_name,
  currency_code,
  currency_precision,
  timezone,
  language_code,
  date_format,
  number_format,
  is_cash_on_delivery_enabled,
  enabled_payment_providers
)
VALUES (
  '11111111-1111-1111-1111-111111111111',
  'GB',
  'United Kingdom',
  'GBP',
  2,
  'Europe/London',
  'en-GB',
  'DD/MM/YYYY',
  '#,##0.00',
  true,
  ARRAY['stripe', 'paypal']
);

INSERT INTO public.tax_profiles (id, business_id, name, country_code, is_active)
VALUES (
  '33333333-3333-3333-3333-333333333333',
  '11111111-1111-1111-1111-111111111111',
  'UK Standard Tax',
  'GB',
  true
);

INSERT INTO public.tax_rules (
  id,
  tax_profile_id,
  name,
  rate_bps,
  tax_type,
  pricing_mode,
  applies_to,
  branch_ids,
  effective_from,
  rounding_rule
)
VALUES (
  '44444444-4444-4444-4444-444444444444',
  '33333333-3333-3333-3333-333333333333',
  'VAT',
  2000,
  'vat',
  'exclusive',
  ARRAY['food', 'drinks'],
  ARRAY[]::uuid[],
  now(),
  'half_up'
);
