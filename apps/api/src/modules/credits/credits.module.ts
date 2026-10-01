import { Module } from '@nestjs/common';
import { CreditsController } from './credits.controller.js';
import { CreditsService } from './credits.service.js';

@Module({
  controllers: [CreditsController],
  providers: [CreditsService],
})
export class CreditsModule {}
