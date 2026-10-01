import { NotFoundException } from '@nestjs/common';
import { PropertiesService } from './properties.service.js';
import { Property } from './property.entity.js';
import { PropertyCategory } from './property-category.enum.js';
import { PropertyStatus } from './property-status.enum.js';
import { PropertyType } from './property-type.enum.js';

function makeQb(data: Property[] = [], total = 0) {
  const qb: Record<string, unknown> = {};
  for (const method of ['where', 'andWhere', 'orderBy', 'skip', 'take']) {
    qb[method] = vi.fn().mockReturnValue(qb);
  }
  qb['getManyAndCount'] = vi.fn().mockResolvedValue([data, total]);
  return qb as unknown as {
    where: ReturnType<typeof vi.fn>;
    andWhere: ReturnType<typeof vi.fn>;
    orderBy: ReturnType<typeof vi.fn>;
    skip: ReturnType<typeof vi.fn>;
    take: ReturnType<typeof vi.fn>;
    getManyAndCount: ReturnType<typeof vi.fn>;
  };
}

function makeRepo(qb: ReturnType<typeof makeQb>, found: Property | null = null) {
  return {
    createQueryBuilder: vi.fn().mockReturnValue(qb),
    findOne: vi.fn().mockResolvedValue(found),
  };
}

function makeProperty(overrides: Partial<Property> = {}): Property {
  return {
    id: '22222222-2222-4222-8222-222222222222',
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
    furnished: false,
    amenities: [],
    isVerified: true,
    isFeatured: false,
    landlordId: null,
    landlord: null,
    description: null,
    createdAt: new Date('2026-01-01T00:00:00Z'),
    updatedAt: new Date('2026-01-01T00:00:00Z'),
    ...overrides,
  };
}

describe('PropertiesService.list', () => {
  it('lists available properties newest-first with default pagination', async () => {
    const qb = makeQb([makeProperty()], 1);
    const service = new PropertiesService(makeRepo(qb) as never);

    const result = await service.list({});

    expect(qb.where).toHaveBeenCalledWith('p.status = :status', {
      status: PropertyStatus.Available,
    });
    expect(qb.orderBy).toHaveBeenCalledWith('p.createdAt', 'DESC');
    expect(qb.skip).toHaveBeenCalledWith(0);
    expect(qb.take).toHaveBeenCalledWith(20);
    expect(result).toEqual({
      data: expect.any(Array),
      meta: { total: 1, page: 1, limit: 20 },
    });
  });

  it('applies region, type, category, price and text filters', async () => {
    const qb = makeQb();
    const service = new PropertiesService(makeRepo(qb) as never);

    await service.list({
      region: 'Dar es Salaam',
      type: PropertyType.Commercial,
      category: PropertyCategory.Shop,
      priceMin: 100000,
      priceMax: 800000,
      q: 'Kariakoo',
      page: 2,
      limit: 10,
    });

    const calls = (qb.andWhere as ReturnType<typeof vi.fn>).mock.calls.map(
      (c) => c[0] as string,
    );
    expect(calls).toContain('p.region = :region');
    expect(calls).toContain('p.type = :type');
    expect(calls).toContain('p.category = :category');
    expect(calls).toContain('p.priceTzs >= :priceMin');
    expect(calls).toContain('p.priceTzs <= :priceMax');
    expect(calls.some((c) => c.includes('LOWER(p.title)'))).toBe(true);
    expect(qb.skip).toHaveBeenCalledWith(10);
    expect(qb.take).toHaveBeenCalledWith(10);
  });

  it('caps limit at 50', async () => {
    const qb = makeQb();
    const service = new PropertiesService(makeRepo(qb) as never);

    const result = await service.list({ limit: 500 });

    expect(qb.take).toHaveBeenCalledWith(50);
    expect(result.meta.limit).toBe(50);
  });
});

describe('PropertiesService.getById', () => {
  it('returns the property when it exists', async () => {
    const property = makeProperty();
    const service = new PropertiesService(
      makeRepo(makeQb(), property) as never,
    );

    await expect(service.getById(property.id)).resolves.toBe(property);
  });

  it('throws NotFoundException for an unknown id', async () => {
    const service = new PropertiesService(makeRepo(makeQb(), null) as never);

    await expect(service.getById('no-such-id')).rejects.toBeInstanceOf(
      NotFoundException,
    );
  });
});
