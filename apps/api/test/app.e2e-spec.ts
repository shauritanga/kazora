import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types';
import RedisMock from 'ioredis-mock';
import { AppModule } from './../src/app.module.js';
import { REDIS_CLIENT } from './../src/infrastructure/redis/redis.module.js';

process.env.DB_TYPE = 'sqljs';

describe('AppController (e2e)', () => {
  let app: INestApplication<App>;
  let redis: RedisMock;

  beforeEach(async () => {
    redis = new RedisMock();
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(REDIS_CLIENT)
      .useValue(redis)
      .compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/')
      .expect(200)
      .expect('Hello World!');
  });

  afterEach(async () => {
    await app.close();
  });
});
