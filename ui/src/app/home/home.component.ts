import { Component, OnInit } from '@angular/core';
import { ConfirmDialogModel, ConfirmDialogComponent } from '../confirm-dialog/confirm-dialog.component';
import {MatDialog} from '@angular/material/dialog';
import {MatSnackBar} from '@angular/material/snack-bar';
import * as moment from 'moment';

import { protobufs } from '../../protobufs';
import {JournalService} from '../journal.service';

enum TextAreaMode {
  EDITING,
  CREATING
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  private mode: TextAreaMode = TextAreaMode.CREATING;
  private journalId: number | Long;
  public journalResponse: protobufs.JournalResponse;
  public selectedJournals: Record<number, boolean> = {};
  public content = '';
  constructor(
    private journalService: JournalService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) { }

  isModeCreating() {
    return this.mode === TextAreaMode.CREATING;
  }

  selectedJournalLength() {
    return Object.values(this.selectedJournals).filter(a => a === true).length;
  }

  ngOnInit() {
    this.journalService.getJournals()
    .then((data) => {
      this.journalResponse = data;
    });
  }

  addJournal(e) {
    e.preventDefault();
    this.journalService.addJournal(this.content)
    .then((data) => {
      this.content = '';
      this.journalResponse.journals.unshift(data);
    });
  }

  editJournal(journal: protobufs.Journal) {
    this.journalId = journal.id;
    this.mode = TextAreaMode.EDITING;
    this.content = journal.content;
  }

  editSubmitJournal(e) {
    e.preventDefault();
    this.journalService.editJournal(this.journalId, this.content)
    .then((data) => {
      this.mode = TextAreaMode.CREATING;
      this.journalId = null;
      this.content = '';
      this.journalResponse.journals = this.journalResponse.journals.map((a) => {
        if (a.id === data.id) {
          return data;
        } else {
          return a;
        }
      });
    });
  }

  deleteJournalConfirm(journal: protobufs.Journal) {
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

  deleteJournalSelectedConfirm() {
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

  deleteJournalSelected() {
    Object.keys(this.selectedJournals).forEach((key) => {
      if (this.selectedJournals[key]) {
        const id = parseInt(key, 10);
        this.journalService.deleteJournal(id)
        .then((data) => {
          this.journalResponse.journals = this.journalResponse.journals.filter((a) => a.id !== id);
        });
      }
    });
    this.selectedJournals = {};
  }

  deleteJournal(journal: protobufs.Journal) {
    return this.journalService.deleteJournal(journal.id)
    .then((data) => {
      this.journalResponse.journals = this.journalResponse.journals.filter((a) => a.id !== journal.id);
    })
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

  undoDeleteJournal(journal: protobufs.Journal) {
    // TODO: Better undo delete
    this.journalService.addJournal(journal.content)
    .then((data) => {
      this.journalResponse.journals.unshift(data);
    });
  }

  doTextareaValueChange(e) {
    this.content = e.target.value;
  }

  fromNow(date) {
    return moment.unix(date).fromNow();
  }

}
