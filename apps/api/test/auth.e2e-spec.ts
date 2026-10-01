import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import RedisMock from 'ioredis-mock';
import { AppModule } from '../src/app.module.js';
import { REDIS_CLIENT } from '../src/infrastructure/redis/redis.module.js';

process.env.DB_TYPE = 'sqljs';
process.env.JWT_SECRET = 'e2e-secret';

describe('Auth (e2e)', () => {
  let app: INestApplication;
  let redis: RedisMock;

  beforeAll(async () => {
    redis = new RedisMock();
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(REDIS_CLIENT)
      .useValue(redis)
      .compile();
    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('full flow: request -> verify -> me', async () => {
    const phone = '0712 345 678';

    const req = await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone })
      .expect(201);
    expect(req.body).toEqual({ status: 'ok' });

    const code = await redis.get('otp:+255712345678');
    expect(code).toMatch(/^\d{6}$/);

    const verify = await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone, code, role: 'landlord' })
      .expect(201);
    expect(verify.body.user.phone).toBe('+255712345678');
    expect(verify.body.user.role).toBe('landlord');
    expect(verify.body.accessToken).toBeTypeOf('string');

    const me = await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', `Bearer ${verify.body.accessToken}`)
      .expect(200);
    expect(me.body).toMatchObject({
      phone: '+255712345678',
      role: 'landlord',
    });
  });

  it('a returning user keeps their original role', async () => {
    const phone = '0733000444';
    await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone })
      .expect(201);
    let code = await redis.get('otp:+255733000444');
    const first = await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone, code, role: 'tenant' })
      .expect(201);
    expect(first.body.user.role).toBe('tenant');

    // Simulate the 60s rate-limit window expiring
    await redis.del('otp:rate:+255733000444');
    await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone })
      .expect(201);
    code = await redis.get('otp:+255733000444');
    const second = await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone, code, role: 'landlord' })
      .expect(201);
    expect(second.body.user.role).toBe('tenant');
    expect(second.body.user.id).toBe(first.body.user.id);
  });

  it('rejects a wrong code with 401', async () => {
    const phone = '0744000555';
    await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone })
      .expect(201);
    const real = await redis.get('otp:+255744000555');
    const wrong = real![0] === '1' ? '2' + real!.slice(1) : '1' + real!.slice(1);

    await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone, code: wrong, role: 'tenant' })
      .expect(401);
  });

  it('rejects verify without a prior request with 401', async () => {
    await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone: '0755000666', code: '123456', role: 'tenant' })
      .expect(401);
  });

  it('rejects /auth/me without a token with 401', async () => {
    await request(app.getHttpServer()).get('/auth/me').expect(401);
  });

  it('rejects /auth/me with a garbage token with 401', async () => {
    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', 'Bearer not.a.jwt')
      .expect(401);
  });

  it('rate-limits rapid OTP requests with 429', async () => {
    const phone = '0766000777';
    await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone })
      .expect(201);
    await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone })
      .expect(429);
  });

  it('rejects an invalid phone with 400', async () => {
    await request(app.getHttpServer())
      .post('/auth/otp/request')
      .send({ phone: '12345' })
      .expect(400);
  });

  it('rejects a malformed code with 400', async () => {
    await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone: '0777000888', code: '12', role: 'tenant' })
      .expect(400);
  });

  it('rejects the admin role from the client with 400', async () => {
    await request(app.getHttpServer())
      .post('/auth/otp/verify')
      .send({ phone: '0788000999', code: '123456', role: 'admin' })
      .expect(400);
  });
});
