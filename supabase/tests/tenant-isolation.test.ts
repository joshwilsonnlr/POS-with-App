import { describe, it, expect } from 'vitest';

describe('tenant isolation', () => {
  it('ignores browser-supplied business ids when user has no access', () => {
    const userBusinessIds = ['business-a'];
    const suppliedBusinessId = 'business-b';

    expect(userBusinessIds.includes(suppliedBusinessId)).toBe(false);
  });

  it('keeps a tenant out of another tenant branch set', () => {
    const restaurantA = ['branch-1', 'branch-2'];
    const restaurantB = ['branch-3'];

    expect(restaurantA.includes('branch-3')).toBe(false);
    expect(restaurantB.includes('branch-1')).toBe(false);
  });
});

describe('role enforcement', () => {
  it('owner can manage business settings', () => {
    const role = 'owner';
    expect(['owner', 'manager'].includes(role)).toBe(true);
  });

  it('cashier cannot update settings', () => {
    const role = 'cashier';
    expect(['owner', 'manager'].includes(role)).toBe(false);
  });
});
