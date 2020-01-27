import { TestBed } from '@angular/core/testing';

import { JournalService } from './journal.service';
import { HttpClientModule } from '@angular/common/http';

describe('JournalService', () => {
  beforeEach(() => TestBed.configureTestingModule({
    imports: [HttpClientModule]
  }));

  it('should be created', () => {
    const service: JournalService = TestBed.get(JournalService);
    expect(service).toBeTruthy();
  });
});
