import { Component, OnInit, ChangeDetectorRef, EventEmitter } from '@angular/core';
import {MatDialog, MatDialogRef} from '@angular/material/dialog';

import { ConfirmDialogModel, ConfirmDialogComponent } from '../confirm-dialog/confirm-dialog.component';
import { enterKeyModalAndSave } from '../encryption-key-modal/encryption-key-modal.component';
import {SavetypeService} from '../savetype.service';
import {EncryptionService} from '../encryption.service';
import {protobufs} from '../../protobufs';
import { MatSelectChange } from '@angular/material';

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.scss']
})
export class SettingsComponent implements OnInit {
  public saveType: protobufs.Journal.JournalSaveType = protobufs.Journal.JournalSaveType.PLAINTEXT;
  public possibleSaveTypes: Array<protobufs.Journal.JournalSaveType> =
    [protobufs.Journal.JournalSaveType.PLAINTEXT, protobufs.Journal.JournalSaveType.ENCRYPTED];
  constructor(
    private savetypeService: SavetypeService,
    private encryptionService: EncryptionService,
    private dialog: MatDialog,
    private changeDetectorRef: ChangeDetectorRef,
  ) {  }

  ngOnInit(): void {
    this.saveType = this.savetypeService.getSaveType();
  }

  saveTypeToString(type: protobufs.Journal.JournalSaveType): string {
    if (type === protobufs.Journal.JournalSaveType.ENCRYPTED) {
      return 'ENCRYPTED';
    } else {
      return 'PLAINTEXT';
    }
  }

  async onChange(event: EventEmitter<MatSelectChange>): Promise<void> {
    const type: protobufs.Journal.JournalSaveType = this.saveType;
    let content = '';
    if (type === protobufs.Journal.JournalSaveType.PLAINTEXT) {
      content = 'This is the default and data will be stored in the cloud in plaintext';
    } else if (type === protobufs.Journal.JournalSaveType.ENCRYPTED) {
      content = 'Data will be stored in encrypted format, if you forget the key, you lose your data';
    }
    const dialogData: ConfirmDialogModel = new ConfirmDialogModel(content, 'Are you sure?');
    const dialogRef: MatDialogRef<ConfirmDialogComponent, boolean> = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: '400px',
      data: dialogData
    });

    const dialogResult: boolean | undefined = await dialogRef.afterClosed().toPromise();
    if (dialogResult) {
      this.saveType = type;
      this.savetypeService.setSaveType(this.saveType);
    } else {
      if (type === protobufs.Journal.JournalSaveType.ENCRYPTED) {
        this.saveType = protobufs.Journal.JournalSaveType.PLAINTEXT;
      } else if (type === protobufs.Journal.JournalSaveType.PLAINTEXT)  {
        this.saveType = protobufs.Journal.JournalSaveType.ENCRYPTED;
      }
    }
    if (this.saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
      const didGetKey = await enterKeyModalAndSave(this.dialog, this.encryptionService);
      if (!didGetKey) {
        this.saveType = protobufs.Journal.JournalSaveType.PLAINTEXT;
      } else {
        this.encryptionService.encryptJournals();
      }
    }
  }
}
