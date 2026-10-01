import { Injectable } from '@nestjs/common';

@Injectable()
export class SubscriptionsService {
  mySubscription() {
    return { status: 'stub', action: 'my-subscription' };
  }

  activate() {
    return { status: 'stub', action: 'activate' };
  }
}
