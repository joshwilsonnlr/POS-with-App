import { createServerSupabaseClient } from '@/lib/supabase/server';

export async function resolveActiveBusinessId() {
  const supabase = createServerSupabaseClient();
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error || !user) {
    throw new Error('Unauthorized');
  }

  const { data: membership } = await supabase
    .from('business_members')
    .select('business_id, role')
    .eq('user_id', user.id)
    .eq('status', 'active')
    .limit(1)
    .single();

  if (!membership) {
    throw new Error('No active business membership');
  }

  return membership.business_id;
}
