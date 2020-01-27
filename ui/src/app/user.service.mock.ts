import { Injectable } from '@angular/core';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class MockUserService {
  public user: protobufs.User;

  getUser(): Promise<protobufs.User> {
    return new Promise<protobufs.User>((resolve) => {
      resolve(new protobufs.User());
    });
  }
}
