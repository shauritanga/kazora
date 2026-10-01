import { BadRequestException } from '@nestjs/common';
import { access, mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { LocalDiskStorage } from './storage.service.js';

describe('LocalDiskStorage', () => {
  let dir: string;
  let storage: LocalDiskStorage;

  beforeEach(async () => {
    dir = await mkdtemp(path.join(tmpdir(), 'kazora-storage-'));
    storage = new LocalDiskStorage(dir, 'http://localhost:3000');
  });

  afterEach(async () => {
    await rm(dir, { recursive: true, force: true });
  });

  it('uploads a file and returns its public url', async () => {
    const stored = await storage.upload(
      Buffer.from('img'),
      'photo.jpg',
      'image/jpeg',
    );
    expect(stored.url).toBe(
      `http://localhost:3000/uploads/${stored.key}`,
    );
    expect(stored.key).toMatch(/^\d{4}\/\d{2}\/[0-9a-f-]+\.jpg$/);
    const content = await readFile(path.join(dir, stored.key));
    expect(content.toString()).toBe('img');
  });

  it('rejects unsupported mimetypes', async () => {
    await expect(
      storage.upload(Buffer.from('x'), 'a.pdf', 'application/pdf'),
    ).rejects.toThrow(BadRequestException);
  });

  it('deletes a stored file', async () => {
    const stored = await storage.upload(
      Buffer.from('img'),
      'photo.png',
      'image/png',
    );
    await storage.delete(stored.key);
    await expect(access(path.join(dir, stored.key))).rejects.toThrow();
  });

  it('rejects path traversal on delete', async () => {
    await expect(storage.delete('../evil.txt')).rejects.toThrow(
      BadRequestException,
    );
  });
});
