import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { fileURLToPath } from 'node:url';

@Global()
@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        if (config.get('DB_TYPE') === 'sqljs') {
          return {
            type: 'sqljs' as const,
            autoSave: false,
            synchronize: true,
            autoLoadEntities: true,
          };
        }
        return {
          type: 'postgres' as const,
          url: config.get<string>('DATABASE_URL'),
          autoLoadEntities: true,
          migrations: [
            fileURLToPath(new URL('./migrations/', import.meta.url)) + '*.js',
          ],
          migrationsRun: true,
          synchronize: false,
        };
      },
    }),
  ],
})
export class DatabaseModule {}
