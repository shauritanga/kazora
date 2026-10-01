import { HttpException, HttpStatus, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AuthService } from './auth.service.js';
import { type RedisLike } from '../../infrastructure/redis/redis.module.js';
import { User } from '../users/user.entity.js';
import { UserRole } from './user-role.enum.js';

class FakeRedis implements RedisLike {
  private store = new Map<string, { value: string; expiresAt: number }>();

  async get(key: string): Promise<string | null> {
    const entry = this.store.get(key);
    if (!entry) return null;
    if (Date.now() > entry.expiresAt) {
      this.store.delete(key);
      return null;
    }
    return entry.value;
  }

  async set(
    key: string,
    value: string,
    mode?: string,
    ttl?: number,
  ): Promise<'OK'> {
    this.store.set(key, {
      value,
      expiresAt: mode === 'EX' ? Date.now() + ttl! * 1000 : Number.POSITIVE_INFINITY,
    });
    return 'OK';
  }

  async del(key: string): Promise<number> {
    return this.store.delete(key) ? 1 : 0;
  }
}

function makeUser(overrides: Partial<User>): User {
  return {
    id: '11111111-1111-4111-8111-111111111111',
    phone: '+255712345678',
    role: UserRole.Tenant,
    createdAt: new Date('2026-01-01T00:00:00Z'),
    updatedAt: new Date('2026-01-01T00:00:00Z'),
    ...overrides,
  };
}

function fakeUserRepo(existing: User[] = []) {
  return {
    findOne: vi.fn(
      async ({ where }: { where: { phone?: string; id?: string } }) =>
        existing.find(
          (u) =>
            (where.phone !== undefined && u.phone === where.phone) ||
            (where.id !== undefined && u.id === where.id),
        ) ?? null,
    ),
    create: vi.fn((data: Partial<User>) => makeUser(data as User)),
    save: vi.fn(async (user: User) => {
      existing.push(user);
      return user;
    }),
  };
}

describe('AuthService', () => {
  let redis: FakeRedis;
  let repo: ReturnType<typeof fakeUserRepo>;
  let jwt: JwtService;
  let service: AuthService;

  beforeEach(() => {
    redis = new FakeRedis();
    repo = fakeUserRepo();
    jwt = new JwtService({ secret: 'test-secret', signOptions: { expiresIn: '1h' } });
    service = new AuthService(redis, repo, jwt);
  });

  describe('requestOtp', () => {
    it('normalizes the phone and stores a 6-digit code for 5 minutes', async () => {
      await service.requestOtp('0712 345 678');
      const code = await redis.get('otp:+255712345678');
      expect(code).toMatch(/^\d{6}$/);
    });

    it('rate-limits repeated requests for the same phone with 429', async () => {
      await service.requestOtp('0712345678');
      const error = await service.requestOtp('0712345678').catch((e) => e);
      expect(error).toBeInstanceOf(HttpException);
      expect(error.getStatus()).toBe(HttpStatus.TOO_MANY_REQUESTS);
    });

    it('rejects invalid phone numbers', async () => {
      await expect(service.requestOtp('12345')).rejects.toThrow();
    });
  });

  describe('verifyOtp', () => {
    it('creates a new user with the selected role and returns a valid token', async () => {
      await service.requestOtp('0712345678');
      const code = (await redis.get('otp:+255712345678'))!;

      const { accessToken, user } = await service.verifyOtp(
        '0712345678',
        code,
        UserRole.Landlord,
      );

      expect(user.role).toBe(UserRole.Landlord);
      expect(user.phone).toBe('+255712345678');
      expect(repo.save).toHaveBeenCalledOnce();
      const payload = jwt.verify(accessToken);
      expect(payload.sub).toBe(user.id);
      expect(payload.role).toBe(UserRole.Landlord);
    });

    it('keeps the existing role for a returning user', async () => {
      repo.findOne.mockResolvedValue(makeUser({ role: UserRole.Tenant }));
      await service.requestOtp('0712345678');
      const code = (await redis.get('otp:+255712345678'))!;

      const { user } = await service.verifyOtp(
        '0712345678',
        code,
        UserRole.Landlord,
      );

      expect(user.role).toBe(UserRole.Tenant);
      expect(repo.save).not.toHaveBeenCalled();
    });

    it('rejects a wrong code', async () => {
      await service.requestOtp('0712345678');
      const code = (await redis.get('otp:+255712345678'))!;
      const wrong = code[0] === '0' ? '1' + code.slice(1) : '0' + code.slice(1);

      await expect(
        service.verifyOtp('0712345678', wrong, UserRole.Tenant),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('rejects a code that has expired', async () => {
      await redis.set('otp:+255712345678', '123456', 'EX', -1);
      await expect(
        service.verifyOtp('0712345678', '123456', UserRole.Tenant),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('rejects verify when no code was requested', async () => {
      await expect(
        service.verifyOtp('0712345678', '123456', UserRole.Tenant),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('is single-use: the code is deleted after a successful verify', async () => {
      await service.requestOtp('0712345678');
      const code = (await redis.get('otp:+255712345678'))!;
      await service.verifyOtp('0712345678', code, UserRole.Tenant);

      await expect(
        service.verifyOtp('0712345678', code, UserRole.Tenant),
      ).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('me', () => {
    it('returns the user profile', async () => {
      repo.findOne.mockResolvedValue(makeUser());
      const profile = await service.me('11111111-1111-4111-8111-111111111111');
      expect(profile).toMatchObject({
        phone: '+255712345678',
        role: UserRole.Tenant,
      });
    });

    it('throws NotFoundException for an unknown user', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(service.me('missing')).rejects.toThrow();
    });
  });
});
