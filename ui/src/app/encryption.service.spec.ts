import { TestBed } from '@angular/core/testing';

import { EncryptionService } from './encryption.service';
import { HttpClientModule } from '@angular/common/http';

describe('EncryptionService', () => {
  beforeEach(() => TestBed.configureTestingModule({
    imports: [HttpClientModule]
  }));

  it('should be created', () => {
    const service: EncryptionService = TestBed.get(EncryptionService);
    expect(service).toBeTruthy();
  });

  it('should set/check/get encryption key', () => {
    const service: EncryptionService = TestBed.get(EncryptionService);
    expect(service.isEncryptionKeyNotFound).toEqual(true);
    service.setEncryptionKey('123456');
    expect(service.isEncryptionKeyNotFound).toEqual(false);
  });

  it('should encrypt/decrypt', () => {
    const service: EncryptionService = TestBed.get(EncryptionService);
    service.setEncryptionKey('123456');
    const content = 'Some content';
    const encrypted = service.encrypt(content);
    const decrypted = service.decrypt(encrypted);
    expect(content === decrypted).toEqual(true);
  });

  it('should decryption fail on bad key', () => {
    const service: EncryptionService = TestBed.get(EncryptionService);
    service.setEncryptionKey('123456');
    const content = 'Some content';
    const encrypted = service.encrypt(content);
    service.setEncryptionKey('12345678');
    const decrypted = service.decrypt(encrypted);
    expect(content === decrypted).toEqual(false);
  });
});
