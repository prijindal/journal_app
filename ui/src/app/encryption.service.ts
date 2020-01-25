import { Injectable } from '@angular/core';
import {MD5, AES, mode, enc, pad } from 'crypto-js';

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

  base64toHEX(base64: string) {
    const raw = atob(base64);
    let HEX = '';
    for ( let i = 0; i < raw.length; i++ ) {
      const hexV = raw.charCodeAt(i).toString(16);
      HEX += (hexV.length === 2 ? hexV : '0' + hexV);
    }
    return HEX.toUpperCase();
  }

  HEXtobase64(myHexString: string) {
    const hexArray = myHexString
    .replace(/\r|\n/g, '')
    .replace(/([\da-fA-F]{2}) ?/g, '0x$1 ')
    .replace(/ +$/, '')
    .split(' ');
    const byteString = String.fromCharCode.apply(null, hexArray);
    const base64string = window.btoa(byteString);
    return base64string;
  }

  setEncryptionKey(encryptionKey: string) {
    this.encryptionKey = MD5(encryptionKey).toString();
  }

  encrypt(decryptedText: string): string {
    const encryptionKey = this.getEncryptionKey();
    if (encryptionKey == null) {
      return '';
    }
    const encrypted = AES.encrypt(decryptedText, this.getEncryptionKey(), {iv: null, mode: mode.ECB, padding: pad.Pkcs7}).toString();
    const encryptedText = btoa(encrypted);
    return encryptedText;
    return encrypted;
  }

  decrypt(encrypted: string): string {
    const encryptionKey = this.getEncryptionKey();
    console.log(encryptionKey);
    if (encryptionKey == null) {
      return '';
    }
    const decryptedText = AES.decrypt(atob(encrypted), encryptionKey, {iv: null, mode: mode.ECB, padding: pad.Pkcs7}).toString(enc.Utf8);
    return decryptedText;
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
