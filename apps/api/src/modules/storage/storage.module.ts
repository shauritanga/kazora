import { Module } from '@nestjs/common';
import { StorageController } from './storage.controller.js';
import { LocalDiskStorage, StorageService } from './storage.service.js';

@Module({
  controllers: [StorageController],
  providers: [
    {
      provide: StorageService,
      useFactory: () => new LocalDiskStorage(),
    },
  ],
  exports: [StorageService],
})
export class StorageModule {}
