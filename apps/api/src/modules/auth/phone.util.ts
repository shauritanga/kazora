import { BadRequestException } from '@nestjs/common';

const E164 = /^\+[1-9]\d{7,14}$/;

export function normalizePhone(input: string): string {
  let phone = input.replace(/[\s\-().]/g, '');
  if (phone.startsWith('0') && phone.length === 10) {
    phone = `+255${phone.slice(1)}`;
  } else if (phone.startsWith('255')) {
    phone = `+${phone}`;
  }
  if (!E164.test(phone)) {
    throw new BadRequestException('Invalid phone number');
  }
  return phone;
}
