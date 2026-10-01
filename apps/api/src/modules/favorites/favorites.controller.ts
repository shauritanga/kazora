import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { FavoritesService } from './favorites.service.js';

@Controller('favorites')
export class FavoritesController {
  constructor(private readonly favoritesService: FavoritesService) {}

  @Get()
  list() {
    return this.favoritesService.list();
  }

  @Post(':propertyId')
  add(@Param('propertyId') propertyId: string) {
    return this.favoritesService.add(propertyId);
  }

  @Delete(':propertyId')
  remove(@Param('propertyId') propertyId: string) {
    return this.favoritesService.remove(propertyId);
  }

  @Post('searches')
  saveSearch(@Body() body: Record<string, unknown>) {
    return this.favoritesService.saveSearch(body);
  }
}
