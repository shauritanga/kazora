import { Body, Controller, Get, Post } from '@nestjs/common';
import { CreditsService } from './credits.service.js';

@Controller('credits')
export class CreditsController {
  constructor(private readonly creditsService: CreditsService) {}

  @Get('me')
  myCredits() {
    return this.creditsService.myCredits();
  }

  @Post('purchase')
  purchase(@Body() body: Record<string, unknown>) {
    return this.creditsService.purchase(body);
  }
}
