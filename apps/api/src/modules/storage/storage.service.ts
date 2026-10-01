import { BadRequestException, Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { mkdir, unlink, writeFile } from 'node:fs/promises';
import path from 'node:path';

export interface StoredFile {
  key: string;
  url: string;
  size: number;
  mimetype: string;
}

@Injectable()
export abstract class StorageService {
  abstract upload(
    buffer: Buffer,
    originalName: string,
    mimetype: string,
  ): Promise<StoredFile>;

  abstract delete(key: string): Promise<void>;
}

const EXTENSIONS: Record<string, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
};

@Injectable()
export class LocalDiskStorage extends StorageService {
  constructor(
    private readonly rootDir: string =
      process.env.UPLOAD_DIR ?? path.resolve(process.cwd(), 'uploads'),
    private readonly baseUrl: string =
      process.env.PUBLIC_URL ?? 'http://localhost:3000',
  ) {
    super();
  }

  async upload(
    buffer: Buffer,
    _originalName: string,
    mimetype: string,
  ): Promise<StoredFile> {
    const extension = EXTENSIONS[mimetype];
    if (!extension) {
      throw new BadRequestException(`Unsupported image type: ${mimetype}`);
    }
    const now = new Date();
    const key = [
      String(now.getUTCFullYear()),
      String(now.getUTCMonth() + 1).padStart(2, '0'),
      `${randomUUID()}.${extension}`,
    ].join('/');
    const filePath = this.resolvePath(key);
    await mkdir(path.dirname(filePath), { recursive: true });
    await writeFile(filePath, buffer);
    return {
      key,
      url: `${this.baseUrl.replace(/\/$/, '')}/uploads/${key}`,
      size: buffer.length,
      mimetype,
    };
  }

  async delete(key: string): Promise<void> {
    await unlink(this.resolvePath(key));
  }

  private resolvePath(key: string): string {
    const root = path.resolve(this.rootDir);
    const filePath = path.resolve(root, key);
    if (!filePath.startsWith(root + path.sep)) {
      throw new BadRequestException('Invalid storage key');
    }
    return filePath;
  }
}
