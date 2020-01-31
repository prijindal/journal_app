import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {protobufs} from '../protobufs';
import * as uuidv4 from 'uuid/v4';

@Injectable({
  providedIn: 'root'
})
export class JournalService {
  public journalResponse: protobufs.JournalResponse | undefined;
  constructor(private http: HttpClient) { }

  getJournals(): Promise<protobufs.JournalResponse> {
    return this.http.get('/journal', {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.JournalResponse.decode(new Uint8Array(data)))
    .then((data) => {
      this.journalResponse = data;
      return data;
    });
  }

  addJournal(content: string, saveType?: protobufs.Journal.JournalSaveType, uuid?: string): Promise<protobufs.Journal> {
    const form = new FormData();
    if (uuid == null) {
      uuid = uuidv4();
    }
    form.append('content', content);
    form.append('uuid', uuid);
    if (saveType != null) {
      form.append('save_type', protobufs.Journal.JournalSaveType[saveType]);
    }
    return this.http.post('/journal', form, {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)))
    .then((data) => {
      if (this.journalResponse != null) {
        this.journalResponse.journals.unshift(data);
      }
      return data;
    });
  }

  deleteJournal(id: number | Long): Promise<protobufs.Journal> {
    return this.http.delete('/journal', {params: {id: id.toString()}, responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)))
    .then((data) => {
      if (this.journalResponse != null) {
        this.journalResponse.journals = this.journalResponse.journals.filter((a) => a.id !== id);
      }
      return data;
    });
  }

  editJournal(
    id: number | Long | null,
    content: string,
    saveType: protobufs.Journal.JournalSaveType | null | undefined = protobufs.Journal.JournalSaveType.PLAINTEXT
  ): Promise<protobufs.Journal> {
    const form = new FormData();
    if (id != null) {
      form.append('id', id.toString());
    }
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
      if (this.journalResponse != null) {
        this.journalResponse.journals = this.journalResponse.journals.map((a) => {
          if (a.id === data.id) {
            return data;
          } else {
            return a;
          }
        });
      }
      return data;
    });
  }
}
