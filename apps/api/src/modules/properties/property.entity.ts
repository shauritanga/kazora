import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from '../users/user.entity.js';
import { PropertyCategory } from './property-category.enum.js';
import { PropertyStatus } from './property-status.enum.js';
import { PropertyType } from './property-type.enum.js';

@Entity('properties')
export class Property {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar' })
  title: string;

  @Column({ type: 'varchar', length: 20 })
  type: PropertyType;

  @Column({ type: 'varchar', length: 20 })
  category: PropertyCategory;

  @Column({ type: 'varchar' })
  region: string;

  @Column({ type: 'varchar' })
  district: string;

  @Column({ type: 'varchar' })
  area: string;

  @Column({ type: 'int', name: 'price_tzs' })
  priceTzs: number;

  @Column({ type: 'simple-array', default: '' })
  photos: string[];

  @Column({ type: 'text', name: 'video_url', nullable: true })
  videoUrl: string | null;

  @Column({
    type: 'varchar',
    length: 20,
    default: PropertyStatus.Available,
  })
  status: PropertyStatus;

  @Column({ type: 'int', default: 0 })
  bedrooms: number;

  @Column({ type: 'int', default: 0 })
  bathrooms: number;

  @Column({ type: 'boolean', default: false })
  furnished: boolean;

  @Column({ type: 'simple-array', default: '' })
  amenities: string[];

  @Column({ type: 'boolean', name: 'is_verified', default: false })
  isVerified: boolean;

  @Column({ type: 'boolean', name: 'is_featured', default: false })
  isFeatured: boolean;

  @Column({ type: 'uuid', name: 'landlord_id', nullable: true })
  landlordId: string | null;

  @ManyToOne(() => User, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'landlord_id' })
  landlord: User | null;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
