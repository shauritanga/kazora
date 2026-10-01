import { Injectable } from '@nestjs/common';

@Injectable()
export class PaymentsService {
  startStkPush(body: Record<string, unknown>) {
    return { status: 'stub', action: 'stk-push', body };
  }

  webhook(gateway: string, body: Record<string, unknown>) {
    return { status: 'stub', action: 'webhook', gateway, body };
  }

  history() {
    return { status: 'stub', action: 'history' };
  }
}
