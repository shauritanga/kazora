import { IsIn, IsString, Length } from 'class-validator';
import { UserRole } from '../user-role.enum.js';

export class VerifyOtpDto {
  @IsString()
  phone: string;

  @IsString()
  @Length(6, 6)
  code: string;

  @IsIn([UserRole.Tenant, UserRole.Landlord])
  role: UserRole;
}
