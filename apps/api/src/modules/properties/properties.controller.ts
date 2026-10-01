import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard.js';
import { ListPropertiesDto } from './dto/list-properties.dto.js';
import { PropertiesService } from './properties.service.js';

@Controller('properties')
export class PropertiesController {
  constructor(private readonly propertiesService: PropertiesService) {}

  @UseGuards(JwtAuthGuard)
  @Get()
  list(@Query() query: ListPropertiesDto) {
    return this.propertiesService.list(query);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  getById(@Param('id') id: string) {
    return this.propertiesService.getById(id);
  }

  @Post()
  create(@Body() body: Record<string, unknown>) {
    return this.propertiesService.create(body);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() body: Record<string, unknown>) {
    return this.propertiesService.update(id, body);
  }

  @Post(':id/contact/reveal')
  revealContact(@Param('id') id: string) {
    return this.propertiesService.revealContact(id);
  }

  @Post(':id/report')
  report(@Param('id') id: string, @Body() body: Record<string, unknown>) {
    return this.propertiesService.report(id, body);
  }
}
