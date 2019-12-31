import { Injectable } from '@angular/core';
import {utils, ModeOfOperation} from 'aes-js';

@Injectable({
  providedIn: 'root'
})
export class EncryptionService {
  private encryptionKey;
  constructor() { }

  isEncryptionKeyNotFound() {
    if (this.encryptionKey == null || this.encryptionKey.length === 0) {
      return true;
    }
    return false;
  }

  getEncryptionKey() {
    let modifiedKey = this.encryptionKey;
    if (this.encryptionKey.length < 32) {
      for (let i = this.encryptionKey.length; i < 32; i += 1) {
        modifiedKey += '.';
      }
    }
    return modifiedKey;
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
    this.encryptionKey = encryptionKey;
  }

  encrypt(decryptedText: string) {
    const encryptionKey = this.getEncryptionKey();
    const encryptionKeyBytes = utils.utf8.toBytes(encryptionKey);
    const decryptedBytes = utils.utf8.toBytes(decryptedText);
    const aesEcb = new ModeOfOperation.ecb(encryptionKeyBytes);
    const encryptedBytes = aesEcb.encrypt(decryptedBytes);
    const encryptedHex = utils.hex.fromBytes(encryptedBytes);
    const encryptedText = this.HEXtobase64(encryptedHex);
    return encryptedText;
  }

  decrypt(encrypted: string) {
    const encryptionKey = this.getEncryptionKey();
    const encryptionKeyBytes = utils.utf8.toBytes(encryptionKey);
    const encryptedHex = this.base64toHEX(encrypted);
    const encryptedBytes = utils.hex.toBytes(encryptedHex);
    const aesEcb = new ModeOfOperation.ecb(encryptionKeyBytes);
    const decryptedBytes = aesEcb.decrypt(encryptedBytes);
    const decryptedText = utils.utf8.fromBytes(decryptedBytes);
    return decryptedText;
  }
}
