import { Injectable } from '@nestjs/common';

@Injectable()
export class CreditsService {
  myCredits() {
    return { status: 'stub', action: 'my-credits' };
  }

  purchase(body: Record<string, unknown>) {
    return { status: 'stub', action: 'purchase', body };
  }
}
