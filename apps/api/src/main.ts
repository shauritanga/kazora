import { ValidationPipe } from '@nestjs/common';
import { NestFactory, NestApplication } from '@nestjs/core';
import { fileURLToPath } from 'node:url';
import { AppModule } from './app.module.js';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter.js';
import { AuditInterceptor } from './common/interceptors/audit.interceptor.js';

async function bootstrap() {
  const app = await NestFactory.create<NestApplication>(AppModule);
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, transform: true }),
  );
  app.useGlobalFilters(new AllExceptionsFilter());
  app.useGlobalInterceptors(new AuditInterceptor());
  app.enableCors();
  const uploadDir =
    process.env.UPLOAD_DIR ??
    fileURLToPath(new URL('../uploads/', import.meta.url));
  app.useStaticAssets(uploadDir, { prefix: '/uploads/' });
  await app.listen(process.env.PORT ?? 3000);
}
await bootstrap();
