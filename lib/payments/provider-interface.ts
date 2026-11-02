export type PaymentProviderName = 'stripe' | 'paypal' | 'adyen' | 'local_gateway';

export interface PaymentProviderConfig {
  provider: PaymentProviderName;
  mode: 'test' | 'live';
  enabled: boolean;
  webhookSecret?: string;
  merchantAccountId?: string;
}

export interface CreateCheckoutSessionInput {
  businessId: string;
  amountMinor: number;
  currency: string;
  orderId: string;
  successUrl: string;
  cancelUrl: string;
}

export interface PaymentProviderAdapter {
  createCheckoutSession(input: CreateCheckoutSessionInput): Promise<{
    checkoutUrl: string;
    providerSessionId: string;
  }>;
  confirmPayment(providerEvent: unknown): Promise<{
    paymentId: string;
    status: 'paid' | 'failed' | 'pending';
  }>;
  retrieveTransaction(transactionId: string): Promise<unknown>;
  refundPayment(paymentId: string, amountMinor: number): Promise<unknown>;
  handleWebhook(event: unknown): Promise<void>;
}
