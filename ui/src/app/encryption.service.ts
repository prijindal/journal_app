import { Injectable } from '@angular/core';
import {MD5, AES, mode, enc, pad, LibWordArray, WordArray } from 'crypto-js';

import {JournalService} from './journal.service';
import { protobufs } from 'src/protobufs';

@Injectable({
  providedIn: 'root'
})
export class EncryptionService {
  private encryptionKey;
  constructor(private journalService: JournalService) { }

  isEncryptionKeyNotFound() {
    if (this.encryptionKey == null || this.encryptionKey.length === 0) {
      return true;
    }
    return false;
  }

  getEncryptionKey() {
    return this.encryptionKey;
  }

  setEncryptionKey(encryptionKey: string) {
    this.encryptionKey = MD5(encryptionKey).toString();
  }

  encrypt(decryptedText: string): string {
    const encryptionKey = this.getEncryptionKey();
    if (encryptionKey == null) {
      return '';
    }
    const encrypted = AES.encrypt(
      enc.Utf8.parse(decryptedText),
      enc.Utf8.parse(encryptionKey),
      {iv: null, mode: mode.ECB, padding: pad.Pkcs7})
    ;
    return enc.Base64.stringify(encrypted.ciphertext);
  }

  decrypt(encrypted: string): string {
    const encryptionKey = this.getEncryptionKey();
    if (encryptionKey == null) {
      return '';
    }
    const decryptedText = AES.decrypt(
      encrypted,
      enc.Utf8.parse(encryptionKey),
      {iv: null, mode: mode.ECB, padding: pad.Pkcs7}
    ).toString();
    return enc.Utf8.stringify(enc.Hex.parse(decryptedText));
  }

  async encryptJournals() {
    const journalsResponse = await this.journalService.getJournals();
    journalsResponse.journals.forEach((journal) => {
      if (journal.saveType !== protobufs.Journal.JournalSaveType.ENCRYPTED) {
        const encrypted = this.encrypt(journal.content);
        this.journalService.editJournal(journal.id, encrypted, protobufs.Journal.JournalSaveType.ENCRYPTED);
      }
    });
  }
}
