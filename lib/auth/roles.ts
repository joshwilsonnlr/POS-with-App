export type AppRole =
  | 'platform_admin'
  | 'owner'
  | 'manager'
  | 'cashier'
  | 'waiter'
  | 'kitchen'
  | 'rider'
  | 'customer';

export function canManageBusiness(role: AppRole): boolean {
  return ['owner', 'manager'].includes(role);
}

export function canAccessStaffOperations(role: AppRole): boolean {
  return ['owner', 'manager', 'cashier', 'waiter', 'kitchen'].includes(role);
}

export function canManagePayments(role: AppRole): boolean {
  return ['owner', 'manager'].includes(role);
}

export function isPlatformAdmin(role: AppRole): boolean {
  return role === 'platform_admin';
}
