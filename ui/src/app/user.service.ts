import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  public user: protobufs.User;

  constructor(private http: HttpClient) { }

  getUser() {
    return this.http.get('/user', {responseType: 'arraybuffer'})
    .toPromise()
    .then(data => protobufs.User.decode(new Uint8Array(data)))
    .then((user) => {
      this.user = user;
    });
  }
}
