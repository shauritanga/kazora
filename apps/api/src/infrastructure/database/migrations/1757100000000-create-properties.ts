import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
} from 'typeorm';
import { PropertyStatus } from '../../../modules/properties/property-status.enum.js';

export class CreateProperties1757100000000 implements MigrationInterface {
  name = 'CreateProperties1757100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"');
    await queryRunner.createTable(
      new Table({
        name: 'properties',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          { name: 'title', type: 'varchar' },
          { name: 'type', type: 'varchar', length: '20' },
          { name: 'category', type: 'varchar', length: '20' },
          { name: 'region', type: 'varchar' },
          { name: 'district', type: 'varchar' },
          { name: 'area', type: 'varchar' },
          { name: 'price_tzs', type: 'int' },
          { name: 'photos', type: 'text', default: "''" },
          {
            name: 'status',
            type: 'varchar',
            length: '20',
            default: `'${PropertyStatus.Available}'`,
          },
          { name: 'bedrooms', type: 'int', default: 0 },
          { name: 'bathrooms', type: 'int', default: 0 },
          { name: 'furnished', type: 'boolean', default: false },
          { name: 'amenities', type: 'text', default: "''" },
          { name: 'is_verified', type: 'boolean', default: false },
          { name: 'is_featured', type: 'boolean', default: false },
          { name: 'landlord_id', type: 'uuid', isNullable: true },
          { name: 'description', type: 'text', isNullable: true },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'updated_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );
    await queryRunner.createForeignKey(
      'properties',
      new TableForeignKey({
        columnNames: ['landlord_id'],
        referencedTableName: 'users',
        referencedColumnNames: ['id'],
        onDelete: 'SET NULL',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('properties', true);
  }
}
