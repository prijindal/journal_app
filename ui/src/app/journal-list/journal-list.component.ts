import { Component, OnInit } from '@angular/core';
import {MatDialog} from '@angular/material/dialog';
import {MatSnackBar} from '@angular/material/snack-bar';
import * as moment from 'moment';

import { protobufs } from '../../protobufs';
import { ConfirmDialogModel, ConfirmDialogComponent } from '../confirm-dialog/confirm-dialog.component';
import {JournalService} from '../journal.service';
import { EncryptionService } from '../encryption.service';
import { enterKeyModalAndSave } from '../encryption-key-modal/encryption-key-modal.component';

@Component({
  selector: 'app-journal-list',
  templateUrl: './journal-list.component.html',
  styleUrls: ['./journal-list.component.scss']
})
export class JournalListComponent implements OnInit {
  public selectedJournals: Record<number, boolean> = {};

  constructor(
    private journalService: JournalService,
    private encryptionService: EncryptionService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) { }

  ngOnInit(): void {
    this.journalService.getJournals();
  }

  get journalResponse(): protobufs.JournalResponse | undefined {
    return this.journalService.journalResponse;
  }

  selectedJournalLength(): number {
    return Object.values(this.selectedJournals).filter(a => a === true).length;
  }

  fromNow(date: number): string {
    return moment.unix(date).fromNow();
  }

  deleteJournalConfirm(journal: protobufs.Journal): void {
    const dialogData = new ConfirmDialogModel(`Delete Journal ${journal.id}`, 'Are you sure you want to delete?');
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: '400px',
      data: dialogData
    });

    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        this.deleteJournal(journal);
      }
    });
  }

  deleteJournal(journal: protobufs.Journal): Promise<void> {
    return this.journalService.deleteJournal(journal.id)
    .then(() => {
      this.snackBar.open(`Deleted journal entry ${journal.id}`, 'Undo', {
        duration: 2000
      })
      .onAction().subscribe(() => {
        this.undoDeleteJournal(journal);
      });
    })
    .catch((err) => {
      console.dir(err);
      this.snackBar.open(err.message, 'Retry', {
        duration: 2000
      })
      .onAction().subscribe(() => {
        this.deleteJournal(journal);
      });
    });
  }

  undoDeleteJournal(journal: protobufs.Journal): void {
    // TODO: Better undo delete
    this.journalService.addJournal(journal.content);
  }

  deleteJournalSelectedConfirm(): void {
    const dialogData = new ConfirmDialogModel(`Delete ${this.selectedJournalLength()} Journal Entries`, 'Are you sure you want to delete?');
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: '400px',
      data: dialogData
    });

    dialogRef.afterClosed().subscribe(dialogResult => {
      if (dialogResult) {
        this.deleteJournalSelected();
      }
    });
  }

  isEncryptionKeyNotFound(journal: protobufs.Journal): boolean {
    if (journal.saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
      return this.encryptionService.isEncryptionKeyNotFound;
    }
    return false;
  }

  enterEncryptionKey(): void {
    enterKeyModalAndSave(this.dialog, this.encryptionService);
  }

  getContent(journal: protobufs.Journal): string {
    if (journal.saveType !== protobufs.Journal.JournalSaveType.ENCRYPTED) {
      return journal.content;
    } else {
      return this.encryptionService.decrypt(journal.content);
    }
  }

  deleteJournalSelected(): void {
    for (const key in this.selectedJournals) {
      if (this.selectedJournals[key]) {
        const id = parseInt(key, 10);
        this.journalService.deleteJournal(id);
      }
    }
    this.selectedJournals = {};
  }
}
