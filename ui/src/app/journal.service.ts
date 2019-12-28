import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class JournalService {
  constructor(private http: HttpClient) { }

  getJournals() {
    return this.http.get('/journal', {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.JournalResponse.decode(new Uint8Array(data)));
  }

  addJournal(content: string) {
    const form = new FormData();
    form.append('content', content);
    return this.http.post('/journal', form, {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)));
  }

  deleteJournal(id: number | Long) {
    return this.http.delete('/journal', {params: {id: id.toString()}, responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)));
  }

  editJournal(id: number | Long, content: string) {
    const form = new FormData();
    form.append('id', id.toString());
    form.append('content', content);
    return this.http.put('/journal', form, {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.Journal.decode(new Uint8Array(data)));
  }
}
