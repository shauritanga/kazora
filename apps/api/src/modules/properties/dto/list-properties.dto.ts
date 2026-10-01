import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';
import { PropertyCategory } from '../property-category.enum.js';
import { PropertyType } from '../property-type.enum.js';

export class ListPropertiesDto {
  @IsOptional()
  @IsString()
  region?: string;

  @IsOptional()
  @IsIn([PropertyType.Residential, PropertyType.Commercial])
  type?: PropertyType;

  @IsOptional()
  @IsIn(Object.values(PropertyCategory))
  category?: PropertyCategory;

  @IsOptional()
  @IsString()
  q?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  priceMin?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  priceMax?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;
}
