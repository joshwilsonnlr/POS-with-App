# Phase 1 Architecture

## Overview
This foundation is designed for a multi-tenant, international restaurant SaaS platform. It keeps each restaurant's data isolated and config-driven.

## Core design principles
- One platform serves many businesses
- Every record is tenant-scoped using `business_id`
- Browser-supplied IDs are ignored unless the user is an active member
- Database Row Level Security is the final enforcement layer
- Country, tax, and payment settings are configurable and not hard-coded
- Platform admin is separate from tenant admin
- Money is expected to be stored in minor units in later phases

## Data model highlights
- `profiles`: one auth profile per user
- `businesses`: restaurant businesses or tenants
- `business_members`: user-to-business membership and role assignment
- `branches`: business branches and locations
- `business_country_settings`: localized country config
- `tax_profiles` and `tax_rules`: product and branch tax rules
- `payment_provider_configs`: placeholder provider configuration
- `subscription_plans` and `subscriptions`: future SaaS billing foundation

## Security model
- Use Supabase Auth for authentication
- Use `business_members` for membership checks
- Use server-side authorization to verify tenant access
- Use database RLS for final enforcement
- Use audit logging for business-sensitive actions

## Launch notes
This repo only contains the secure foundation for Phase 1 and is intentionally not a full restaurant platform yet.
