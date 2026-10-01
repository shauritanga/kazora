import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

export class AddVideoUrlToProperties1757200000000 implements MigrationInterface {
  name = 'AddVideoUrlToProperties1757200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.addColumn(
      'properties',
      new TableColumn({
        name: 'video_url',
        type: 'text',
        isNullable: true,
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn('properties', 'video_url');
  }
}
