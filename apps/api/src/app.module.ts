import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { DatabaseModule } from './infrastructure/database/database.module.js';
import { RedisModule } from './infrastructure/redis/redis.module.js';
import { AuthModule } from './modules/auth/auth.module.js';
import { PropertiesModule } from './modules/properties/properties.module.js';
import { PaymentsModule } from './modules/payments/payments.module.js';
import { SubscriptionsModule } from './modules/subscriptions/subscriptions.module.js';
import { CreditsModule } from './modules/credits/credits.module.js';
import { FavoritesModule } from './modules/favorites/favorites.module.js';
import { ReportsModule } from './modules/reports/reports.module.js';
import { AdminModule } from './modules/admin/admin.module.js';
import { StorageModule } from './modules/storage/storage.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DatabaseModule,
    RedisModule,
    AuthModule,
    StorageModule,
    PropertiesModule,
    PaymentsModule,
    SubscriptionsModule,
    CreditsModule,
    FavoritesModule,
    ReportsModule,
    AdminModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
