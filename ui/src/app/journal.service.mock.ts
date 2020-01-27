import { Injectable } from '@angular/core';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class MockJournalService {
  public journalResponse: protobufs.JournalResponse | undefined;

  async getJournals(): Promise<protobufs.JournalResponse> {
    return new protobufs.JournalResponse({
      journals: []
    });
  }
}
