import { MatDialogRef } from '@angular/material';
import { Component, OnInit } from '@angular/core';
import {MatDialog} from '@angular/material/dialog';
import { EncryptionService } from '../encryption.service';

export async function enterKeyModalAndSave(dialog: MatDialog, encryptionService: EncryptionService): Promise<boolean> {
  const dialogRefEnc = dialog.open<
  EncryptionKeyModalComponent,
  any,
  {encryptionKey: string, shouldSave: boolean}
  >(EncryptionKeyModalComponent, {
    maxWidth: '400px',
  });
  const encryptionKeyModal = await dialogRefEnc.afterClosed().toPromise();
  if (encryptionKeyModal == null) {
    return false;
  } else {
    const encryptionKey = encryptionKeyModal.encryptionKey;
    const shouldSave = encryptionKeyModal.shouldSave;
    if (encryptionKey == null) {
      return false;
    } else {
      encryptionService.setEncryptionKey(encryptionKey);
      return true;
    }
  }
}

@Component({
  selector: 'app-encryption-key-modal',
  templateUrl: './encryption-key-modal.component.html',
  styleUrls: ['./encryption-key-modal.component.scss']
})
export class EncryptionKeyModalComponent implements OnInit {
  encryptionKey: string = '';
  shouldSave: boolean = false;

  constructor(
    public dialogRef: MatDialogRef<EncryptionKeyModalComponent, EncryptionKeyModalReturn | null>,
  ) {}

  ngOnInit(): void {
  }

  onPrompt(): void {
    // Close the dialog, return true
    this.dialogRef.close({encryptionKey: this.encryptionKey, shouldSave: this.shouldSave});
  }

  onDismiss(): void {
    // Close the dialog, return false
    this.dialogRef.close(null);
  }
}

export interface EncryptionKeyModalReturn {encryptionKey: string; shouldSave: boolean; }
