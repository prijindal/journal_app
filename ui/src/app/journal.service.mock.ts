import { Injectable } from '@angular/core';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class MockJournalService {
  public journalResponse: protobufs.JournalResponse;

  getJournals(): Promise<protobufs.JournalResponse> {
    return new Promise<protobufs.JournalResponse>((resolve) => {
      resolve(new protobufs.JournalResponse());
    });
  }
}
