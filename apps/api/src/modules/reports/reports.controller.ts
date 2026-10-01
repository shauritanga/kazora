import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
} from '@nestjs/common';
import { ReportsService } from './reports.service.js';

@Controller('reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get()
  list() {
    return this.reportsService.list();
  }

  @Post('properties/:propertyId')
  reportProperty(@Param('propertyId') propertyId: string, @Body() body: Record<string, unknown>) {
    return this.reportsService.reportProperty(propertyId, body);
  }

  @Patch(':id/resolve')
  resolve(@Param('id') id: string) {
    return this.reportsService.resolve(id);
  }
}
