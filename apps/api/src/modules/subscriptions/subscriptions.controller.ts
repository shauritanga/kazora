import { Controller, Get, Post } from '@nestjs/common';
import { SubscriptionsService } from './subscriptions.service.js';

@Controller('subscriptions')
export class SubscriptionsController {
  constructor(private readonly subscriptionsService: SubscriptionsService) {}

  @Get('me')
  mySubscription() {
    return this.subscriptionsService.mySubscription();
  }

  @Post('activate')
  activate() {
    return this.subscriptionsService.activate();
  }
}
