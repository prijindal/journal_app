import { Injectable } from '@angular/core';

import {protobufs} from '../protobufs';

@Injectable({
  providedIn: 'root'
})
export class SavetypeService {

  constructor() { }

  getSaveType(): protobufs.Journal.JournalSaveType {
    const saveType = localStorage.getItem('SAVE_TYPE');
    if (saveType === 'PLAINTEXT') {
      return protobufs.Journal.JournalSaveType.PLAINTEXT;
    } else if (saveType === 'ENCRYPTED') {
      return protobufs.Journal.JournalSaveType.ENCRYPTED;
    }
    return protobufs.Journal.JournalSaveType.PLAINTEXT;
  }

  setSaveType(saveType: protobufs.Journal.JournalSaveType): void {
    localStorage.setItem('SAVE_TYPE', protobufs.Journal.JournalSaveType[saveType]);
  }
}
