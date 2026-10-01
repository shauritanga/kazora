import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { StorageService } from './storage.service.js';

const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

@Controller('storage')
export class StorageController {
  constructor(private readonly storage: StorageService) {}

  @Post('upload')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: MAX_FILE_SIZE } }),
  )
  upload(@UploadedFile() file: Express.Multer.File) {
    return this.storage.upload(file.buffer, file.originalname, file.mimetype);
  }
}
