import { Injectable } from '@angular/core';
import {MD5, AES, mode, enc, pad, lib } from 'crypto-js';

import {JournalService} from './journal.service';
import { protobufs } from 'src/protobufs';

@Injectable({
  providedIn: 'root'
})
export class EncryptionService {
  private encryptionKey: string | undefined;
  constructor(private journalService: JournalService) { }

  get isEncryptionKeyNotFound(): boolean {
    if (this.encryptionKey == null || this.encryptionKey.length === 0) {
      return true;
    }
    return false;
  }

  private getEncryptionKey(): string | undefined {
    return this.encryptionKey;
  }

  setEncryptionKey(encryptionKey: string): void {
    this.encryptionKey = MD5(encryptionKey).toString();
  }

  encrypt(decryptedText: string): string {
    const encryptionKey = this.getEncryptionKey();
    if (encryptionKey == null) {
      return '';
    }
    const iv = lib.WordArray.random(128 / 8);
    const encrypted = AES.encrypt(
      enc.Utf8.parse(decryptedText),
      enc.Utf8.parse(encryptionKey),
      {iv, mode: mode.CBC, padding: pad.Pkcs7})
    ;
    const encryptedText = enc.Base64.stringify(encrypted.ciphertext);
    const transitmessage = enc.Base64.stringify(iv) + encryptedText;
    return transitmessage;
  }

  decrypt(transitmessage: string): string {
    const iv = enc.Base64.parse(transitmessage.substr(0, 24));
    const encrypted = transitmessage.substring(24);
    const encryptionKey = this.getEncryptionKey();
    if (encryptionKey == null) {
      return '';
    }
    const decryptedText = AES.decrypt(
      encrypted,
      enc.Utf8.parse(encryptionKey),
      {iv, mode: mode.CBC, padding: pad.Pkcs7}
    ).toString();
    return enc.Utf8.stringify(enc.Hex.parse(decryptedText));
  }

  async encryptJournals(): Promise<void> {
    const journalsResponse = await this.journalService.getJournals();
    journalsResponse.journals.forEach((journal) => {
      if (journal.saveType !== protobufs.Journal.JournalSaveType.ENCRYPTED && journal.content && journal.id) {
        const encrypted = this.encrypt(journal.content);
        this.journalService.editJournal(journal.id, encrypted, protobufs.Journal.JournalSaveType.ENCRYPTED);
      }
    });
  }
}
