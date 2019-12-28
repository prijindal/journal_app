import { Component, OnInit } from '@angular/core';
import { ConfirmDialogModel, ConfirmDialogComponent } from '../confirm-dialog/confirm-dialog.component';
import {MatDialog} from '@angular/material/dialog';
import {MatSnackBar} from '@angular/material/snack-bar';
import * as moment from "moment";

import { protobufs } from "../../protobufs"
import {JournalService} from "../journal.service"

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
  private mode: TextAreaMode = TextAreaMode.CREATING
  private journal:protobufs.Journal
  private journalResponse:protobufs.JournalResponse;
  private content:string = ""
  constructor(
    private journalService:JournalService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) { }

  isModeCreating() {
    return this.mode == TextAreaMode.CREATING
  }

  ngOnInit() {
    this.journalService.getJournals()
    .then((data) => {
      this.journalResponse = data
    })
  }

  addJournal(e) {
    e.preventDefault()
    this.journalService.addJournal(this.content)
    .then((data) => {
      this.content = "a"
      this.journalResponse.journals.unshift(data)
    })
  }

  editJournal(journal:protobufs.Journal) {
    this.journal = journal
    this.mode = TextAreaMode.EDITING
  }

  editSubmitJournal(e) {
    e.preventDefault()
    this.journalService.editJournal(this.journal)
    .then((data) => {
      this.mode = TextAreaMode.CREATING
      this.journal = null
      this.journalResponse.journals.map((a) => {
        if(a.id == data.id) {
          return data
        } else {
          return a
        }
      })
    })
  }

  deleteJournalConfirm(journal: protobufs.Journal) {
    const dialogData = new ConfirmDialogModel(`Delete Journal ${journal.id}`, "Are you sure you want to delete?");
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    });

    dialogRef.afterClosed().subscribe(dialogResult => {
      if(dialogResult) {
        this.deleteJournal(journal)
      }
    });
  }

  deleteJournal(journal: protobufs.Journal) {
    return this.journalService.deleteJournal(journal.id)
    .then((data) => {
      this.journalResponse.journals = this.journalResponse.journals.filter((a) => a.id != journal.id)
    })
    .then(() => {
      this.snackBar.open(`Deleted journal entry ${journal.id}`, "Undo", {
        duration: 2000
      })
      .onAction().subscribe(() => {
        this.undoDeleteJournal(journal)
      })
    })
    .catch((err) => {
      console.dir(err)
      this.snackBar.open(err.message, "Retry", {
        duration: 2000
      })
      .onAction().subscribe(() => {
        this.deleteJournal(journal)
      })
    })
  }

  undoDeleteJournal(journal: protobufs.Journal) {
    // TODO: Better undo delete
    this.journalService.addJournal(journal.content)
    .then((data) => {
      this.journalResponse.journals.unshift(data)
    })
  }

  doTextareaValueChange(e) {
    if(this.isModeCreating()) {
      this.content = e.target.value
    } else {
      this.journal.content = e.target.value
    }
  }

  fromNow(date) {
    return moment.unix(date).fromNow()
  }

}
