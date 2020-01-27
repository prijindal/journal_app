import { Injectable } from '@angular/core';
import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class MockUserService {
  public user: protobufs.User | undefined;

  async getUser(): Promise<protobufs.User> {
    return new protobufs.User();
  }
}
