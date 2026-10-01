import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { PaymentsService } from './payments.service.js';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('stk-push')
  startStkPush(@Body() body: Record<string, unknown>) {
    return this.paymentsService.startStkPush(body);
  }

  @Post('webhook/:gateway')
  webhook(@Param('gateway') gateway: string, @Body() body: Record<string, unknown>) {
    return this.paymentsService.webhook(gateway, body);
  }

  @Get('history')
  history() {
    return this.paymentsService.history();
  }
}
