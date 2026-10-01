import { Body, Controller, Get, Param, Patch } from '@nestjs/common';
import { AdminService } from './admin.service.js';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('moderation/queue')
  moderationQueue() {
    return this.adminService.moderationQueue();
  }

  @Patch('moderation/:propertyId/approve')
  approve(@Param('propertyId') propertyId: string) {
    return this.adminService.approve(propertyId);
  }

  @Patch('moderation/:propertyId/reject')
  reject(@Param('propertyId') propertyId: string, @Body() body: Record<string, unknown>) {
    return this.adminService.reject(propertyId, body);
  }

  @Get('users')
  users() {
    return this.adminService.users();
  }

  @Get('payments')
  payments() {
    return this.adminService.payments();
  }

  @Get('stats')
  stats() {
    return this.adminService.stats();
  }
}
