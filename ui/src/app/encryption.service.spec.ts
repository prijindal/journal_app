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

  it('should encrypt/decrypt', () => {
    const service: EncryptionService = TestBed.get(EncryptionService);
    service.setEncryptionKey('123456');
    const content = 'Some content';
    const encrypted = service.encrypt(content);
    const decrypted = service.decrypt(encrypted);
    expect(content === decrypted).toEqual(true);
  });
});
