import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ListPropertiesDto } from './dto/list-properties.dto.js';
import { Property } from './property.entity.js';
import { PropertyStatus } from './property-status.enum.js';

export interface PropertyListMeta {
  total: number;
  page: number;
  limit: number;
}

export interface PropertyListResult {
  data: Property[];
  meta: PropertyListMeta;
}

const DEFAULT_PAGE = 1;
const DEFAULT_LIMIT = 20;
const MAX_LIMIT = 50;

@Injectable()
export class PropertiesService {
  constructor(
    @InjectRepository(Property)
    private readonly properties: Repository<Property>,
  ) {}

  async list(query: ListPropertiesDto): Promise<PropertyListResult> {
    const page = query.page ?? DEFAULT_PAGE;
    const limit = Math.min(query.limit ?? DEFAULT_LIMIT, MAX_LIMIT);
    const qb = this.properties
      .createQueryBuilder('p')
      .where('p.status = :status', { status: PropertyStatus.Available });

    if (query.region) {
      qb.andWhere('p.region = :region', { region: query.region });
    }
    if (query.type) {
      qb.andWhere('p.type = :type', { type: query.type });
    }
    if (query.category) {
      qb.andWhere('p.category = :category', { category: query.category });
    }
    if (query.priceMin !== undefined) {
      qb.andWhere('p.priceTzs >= :priceMin', { priceMin: query.priceMin });
    }
    if (query.priceMax !== undefined) {
      qb.andWhere('p.priceTzs <= :priceMax', { priceMax: query.priceMax });
    }
    if (query.q) {
      const q = `%${query.q.toLowerCase()}%`;
      qb.andWhere(
        '(LOWER(p.title) LIKE :q OR LOWER(p.area) LIKE :q OR LOWER(p.district) LIKE :q)',
        { q },
      );
    }

    qb.orderBy('p.createdAt', 'DESC')
      .skip((page - 1) * limit)
      .take(limit);
    const [data, total] = await qb.getManyAndCount();
    return { data, meta: { total, page, limit } };
  }

  async getById(id: string): Promise<Property> {
    const property = await this.properties.findOne({ where: { id } });
    if (!property) {
      throw new NotFoundException('Property not found');
    }
    return property;
  }

  create(body: Record<string, unknown>) {
    return { status: 'stub', action: 'create', body };
  }

  update(id: string, body: Record<string, unknown>) {
    return { status: 'stub', action: 'update', id, body };
  }

  revealContact(id: string) {
    return { status: 'stub', action: 'contact/reveal', id };
  }

  report(id: string, body: Record<string, unknown>) {
    return { status: 'stub', action: 'report', id, body };
  }
}
