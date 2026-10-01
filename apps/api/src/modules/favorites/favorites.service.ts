import { Injectable } from '@nestjs/common';

@Injectable()
export class FavoritesService {
  list() {
    return { status: 'stub', action: 'list' };
  }

  add(propertyId: string) {
    return { status: 'stub', action: 'add', propertyId };
  }

  remove(propertyId: string) {
    return { status: 'stub', action: 'remove', propertyId };
  }

  saveSearch(body: Record<string, unknown>) {
    return { status: 'stub', action: 'save-search', body };
  }
}
