import { TestBed } from '@angular/core/testing';

import { SavetypeService } from './savetype.service';

describe('SavetypeService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: SavetypeService = TestBed.get(SavetypeService);
    expect(service).toBeTruthy();
  });
});
