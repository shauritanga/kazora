import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import request from 'supertest';
import RedisMock from 'ioredis-mock';
import { Repository } from 'typeorm';
import { AppModule } from '../src/app.module.js';
import { REDIS_CLIENT } from '../src/infrastructure/redis/redis.module.js';
import { Property } from '../src/modules/properties/property.entity.js';
import { PropertyCategory } from '../src/modules/properties/property-category.enum.js';
import { PropertyStatus } from '../src/modules/properties/property-status.enum.js';
import { PropertyType } from '../src/modules/properties/property-type.enum.js';

process.env.DB_TYPE = 'sqljs';
process.env.JWT_SECRET = 'e2e-secret';

describe('Properties (e2e)', () => {
  let app: INestApplication;
  let repo: Repository<Property>;
  let token: string;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(REDIS_CLIENT)
      .useValue(new RedisMock())
      .compile();
    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await app.init();

    repo = app.get<Repository<Property>>(getRepositoryToken(Property));
    await repo.save([
      repo.create({
        id: '11111111-1111-4111-8111-111111111111',
        title: '2BR Apartment in Mikocheni',
        type: PropertyType.Residential,
        category: PropertyCategory.Apartment,
        region: 'Dar es Salaam',
        district: 'Kinondoni',
        area: 'Mikocheni',
        priceTzs: 650000,
        photos: [],
        status: PropertyStatus.Available,
        bedrooms: 2,
        bathrooms: 2,
        isVerified: true,
        isFeatured: true,
      }),
      repo.create({
        id: '22222222-2222-4222-8222-222222222222',
        title: 'Shop in Kariakoo Market Area',
        type: PropertyType.Commercial,
        category: PropertyCategory.Shop,
        region: 'Dar es Salaam',
        district: 'Ilala',
        area: 'Kariakoo',
        priceTzs: 700000,
        photos: [],
        status: PropertyStatus.Available,
        isVerified: true,
      }),
      repo.create({
        id: '33333333-3333-4333-8333-333333333333',
        title: 'Rented Room in Temeke',
        type: PropertyType.Residential,
        category: PropertyCategory.Room,
        region: 'Dar es Salaam',
        district: 'Temeke',
        area: 'Mbagala',
        priceTzs: 120000,
        photos: [],
        status: PropertyStatus.Rented,
      }),
    ]);

    token = await app.get(JwtService).signAsync({
      sub: '99999999-9999-4999-8999-999999999999',
      phone: '+255700000000',
      role: 'tenant',
    });
  });

  afterAll(async () => {
    await app.close();
  });

  const auth = (r: request.Test) => r.set('Authorization', `Bearer ${token}`);

  it('rejects listing without a token with 401', async () => {
    await request(app.getHttpServer()).get('/properties').expect(401);
  });

  it('lists available properties with pagination meta', async () => {
    const res = await auth(request(app.getHttpServer()).get('/properties'))
      .expect(200);
    expect(res.body.meta).toMatchObject({ total: 2, page: 1, limit: 20 });
    expect(res.body.data).toHaveLength(2);
    expect(res.body.data.map((p: { id: string }) => p.id)).not.toContain(
      '33333333-3333-4333-8333-333333333333',
    );
  });

  it('filters by type and region', async () => {
    const res = await auth(
      request(app.getHttpServer()).get(
        '/properties?type=commercial&region=Dar%20es%20Salaam',
      ),
    ).expect(200);
    expect(res.body.meta.total).toBe(1);
    expect(res.body.data[0].title).toContain('Kariakoo');
  });

  it('searches by text across title, area and district', async () => {
    const res = await auth(
      request(app.getHttpServer()).get('/properties?q=mikocheni'),
    ).expect(200);
    expect(res.body.meta.total).toBe(1);
    expect(res.body.data[0].area).toBe('Mikocheni');
  });

  it('paginates with limit and page', async () => {
    const res = await auth(
      request(app.getHttpServer()).get('/properties?limit=1&page=2'),
    ).expect(200);
    expect(res.body.meta).toMatchObject({ total: 2, page: 2, limit: 1 });
    expect(res.body.data).toHaveLength(1);
  });

  it('rejects an invalid type with 400', async () => {
    await auth(request(app.getHttpServer()).get('/properties?type=castle'))
      .expect(400);
  });

  it('returns a single property by id', async () => {
    const res = await auth(
      request(app.getHttpServer()).get(
        '/properties/11111111-1111-4111-8111-111111111111',
      ),
    ).expect(200);
    expect(res.body.title).toBe('2BR Apartment in Mikocheni');
  });

  it('returns 404 for an unknown property id', async () => {
    await auth(
      request(app.getHttpServer()).get('/properties/00000000-0000-4000-8000-000000000000'),
    ).expect(404);
  });
});
