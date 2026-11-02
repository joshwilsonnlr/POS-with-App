CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    NEW.email
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.business_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.business_country_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tax_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tax_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_provider_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "businesses_visible_to_members_or_platform_admin"
ON public.businesses
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.business_members bm
    WHERE bm.business_id = businesses.id
      AND bm.user_id = auth.uid()
      AND bm.status = 'active'
  )
  OR EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND p.is_platform_admin = true
  )
);

CREATE POLICY "business_members_visible_to_owner_or_self"
ON public.business_members
FOR SELECT
USING (
  user_id = auth.uid()
  OR EXISTS (
    SELECT 1
    FROM public.business_members bm
    WHERE bm.business_id = business_members.business_id
      AND bm.user_id = auth.uid()
      AND bm.role IN ('owner', 'manager')
      AND bm.status = 'active'
  )
);

CREATE POLICY "branches_visible_to_business_members"
ON public.branches
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.business_members bm
    WHERE bm.business_id = branches.business_id
      AND bm.user_id = auth.uid()
      AND bm.status = 'active'
  )
);

CREATE POLICY "country_settings_read_members"
ON public.business_country_settings
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.business_members bm
    WHERE bm.business_id = business_country_settings.business_id
      AND bm.user_id = auth.uid()
      AND bm.status = 'active'
  )
);

CREATE POLICY "country_settings_write_owner_manager"
ON public.business_country_settings
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.business_members bm
    WHERE bm.business_id = business_country_settings.business_id
      AND bm.user_id = auth.uid()
      AND bm.role IN ('owner', 'manager')
      AND bm.status = 'active'
  )
);
