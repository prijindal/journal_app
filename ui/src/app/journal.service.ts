import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class JournalService {
  public journalResponse: protobufs.JournalResponse;
  constructor(private http: HttpClient) { }

  getJournals() {
    return this.http.get('/journal', {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.JournalResponse.decode(new Uint8Array(data)))
    .then((data) => {
      this.journalResponse = data;
    });
  }

  addJournal(content: string) {
    const form = new FormData();
    form.append('content', content);
    return this.http.post('/journal', form, {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)))
    .then((data) => {
      this.journalResponse.journals.unshift(data);
      return data;
    });
  }

  deleteJournal(id: number | Long) {
    return this.http.delete('/journal', {params: {id: id.toString()}, responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)))
    .then((data) => {
      this.journalResponse.journals = this.journalResponse.journals.filter((a) => a.id !== id);
    });
  }

  editJournal(
    id: number | Long,
    content: string,
    saveType: protobufs.Journal.JournalSaveType = protobufs.Journal.JournalSaveType.PLAINTEXT
  ) {
    const form = new FormData();
    form.append('id', id.toString());
    form.append('content', content);
    if (saveType != null) {
      if (saveType === protobufs.Journal.JournalSaveType.PLAINTEXT) {
        form.append('save_type', 'PLAINTEXT');
      } else if (saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
        form.append('save_type', 'ENCRYPTED');
      }
    }
    return this.http.put('/journal', form, {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)))
    .then((data) => {
      this.journalResponse.journals = this.journalResponse.journals.map((a) => {
        if (a.id === data.id) {
          return data;
        } else {
          return a;
        }
      });
      return data;
    });
  }
}
