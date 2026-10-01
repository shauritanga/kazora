import {
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { randomInt, timingSafeEqual } from 'node:crypto';
import { Repository } from 'typeorm';
import {
  REDIS_CLIENT,
  type RedisLike,
} from '../../infrastructure/redis/redis.module.js';
import { User } from '../users/user.entity.js';
import { UserRole } from './user-role.enum.js';
import { normalizePhone } from './phone.util.js';

const OTP_TTL_SECONDS = 300;
const OTP_RATE_LIMIT_SECONDS = 60;

export interface UserProfile {
  id: string;
  phone: string;
  role: UserRole;
  createdAt: Date;
}

function toProfile(user: User): UserProfile {
  return {
    id: user.id,
    phone: user.phone,
    role: user.role,
    createdAt: user.createdAt,
  };
}

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: RedisLike,
    @InjectRepository(User) private readonly users: Repository<User>,
    private readonly jwt: JwtService,
  ) {}

  async requestOtp(phone: string): Promise<{ status: 'ok' }> {
    const normalized = normalizePhone(phone);
    const rateKey = `otp:rate:${normalized}`;
    if (await this.redis.get(rateKey)) {
      throw new HttpException(
        'Too many OTP requests, try again later',
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }
    const code = String(randomInt(0, 1_000_000)).padStart(6, '0');
    await this.redis.set(rateKey, '1', 'EX', OTP_RATE_LIMIT_SECONDS);
    await this.redis.set(`otp:${normalized}`, code, 'EX', OTP_TTL_SECONDS);
    this.logger.log(`OTP for ${normalized}: ${code}`);
    return { status: 'ok' };
  }

  async verifyOtp(
    phone: string,
    code: string,
    role: UserRole,
  ): Promise<{ accessToken: string; user: UserProfile }> {
    const normalized = normalizePhone(phone);
    const key = `otp:${normalized}`;
    const stored = await this.redis.get(key);
    if (!stored || !this.codesMatch(stored, code)) {
      throw new UnauthorizedException('Invalid or expired code');
    }
    await this.redis.del(key);
    let user = await this.users.findOne({ where: { phone: normalized } });
    if (!user) {
      user = await this.users.save(
        this.users.create({ phone: normalized, role }),
      );
    }
    const accessToken = await this.jwt.signAsync({
      sub: user.id,
      phone: user.phone,
      role: user.role,
    });
    return { accessToken, user: toProfile(user) };
  }

  async me(userId: string): Promise<UserProfile> {
    const user = await this.users.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return toProfile(user);
  }

  private codesMatch(stored: string, provided: string): boolean {
    const a = Buffer.from(stored);
    const b = Buffer.from(provided);
    if (a.length !== b.length) return false;
    return timingSafeEqual(a, b);
  }
}
