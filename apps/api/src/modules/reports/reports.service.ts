import { Injectable } from '@nestjs/common';

@Injectable()
export class ReportsService {
  list() {
    return { status: 'stub', action: 'list' };
  }

  reportProperty(propertyId: string, body: Record<string, unknown>) {
    return { status: 'stub', action: 'report-property', propertyId, body };
  }

  resolve(id: string) {
    return { status: 'stub', action: 'resolve', id };
  }
}
