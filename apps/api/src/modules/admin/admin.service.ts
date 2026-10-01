import { Injectable } from '@nestjs/common';

@Injectable()
export class AdminService {
  moderationQueue() {
    return { status: 'stub', action: 'moderation-queue' };
  }

  approve(propertyId: string) {
    return { status: 'stub', action: 'approve', propertyId };
  }

  reject(propertyId: string, body: Record<string, unknown>) {
    return { status: 'stub', action: 'reject', propertyId, body };
  }

  users() {
    return { status: 'stub', action: 'users' };
  }

  payments() {
    return { status: 'stub', action: 'payments' };
  }

  stats() {
    return { status: 'stub', action: 'stats' };
  }
}
