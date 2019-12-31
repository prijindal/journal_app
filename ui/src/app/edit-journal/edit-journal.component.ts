import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import {MatSnackBar} from '@angular/material/snack-bar';
import {JournalService} from '../journal.service';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';
import { protobufs } from 'src/protobufs';
import { EncryptionService } from '../encryption.service';

@Component({
  selector: 'app-edit-journal',
  templateUrl: './edit-journal.component.html',
  styleUrls: ['./edit-journal.component.scss']
})
export class EditJournalComponent implements OnInit {
  private journalId: number;
  public content = '';
  public isHandset: boolean;
  constructor(
    private route: ActivatedRoute,
    private journalService: JournalService,
    private encryptionService: EncryptionService,
    private snackBar: MatSnackBar,
    breakpointObserver: BreakpointObserver,
  ) {
    const layoutChanges = breakpointObserver.observe([
      Breakpoints.HandsetLandscape,
      Breakpoints.HandsetPortrait
    ]);
    layoutChanges.subscribe(result => {
      this.isHandset = result.matches;
    });
  }

  ngOnInit() {
    this.route.paramMap.subscribe((params: ParamMap) => {
      this.journalId = parseInt(params.get('id'), 10);
      if (this.journalService.journalResponse == null) {
        this.journalService.getJournals().then(() => {
          this.getJournalContent();
        });
      } else {
        this.getJournalContent();
      }
    });
  }

  getJournal() {
    const journals = this.journalService.journalResponse.journals.filter((a) => a.id === this.journalId);
    if (journals.length > 0) {
      return journals[0];
    } else {
      return null;
    }
  }

  getJournalContent() {
    const journals = this.journalService.journalResponse.journals.filter((a) => a.id === this.journalId);
    if (journals.length > 0) {
      if (journals[0].saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
        this.content = this.encryptionService.decrypt(journals[0].content);
      } else {
        this.content = journals[0].content;
      }
    } else {
      this.snackBar.open(`Journal Entry ${this.journalId} not found`, 'Retry', {
        duration: 2000
      })
      .onAction().subscribe(() => {
        window.location.reload();
      });
    }
  }

  editSubmitJournal(newContent: string) {
    if (this.getJournal().saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
      newContent = this.encryptionService.encrypt(newContent);
    }
    this.journalService.editJournal(this.journalId, newContent, this.getJournal().saveType)
    .then((data) => {
      this.journalId = null;
      this.snackBar.open(`Succesfully edited journal ${data.id}`, 'Undo', {
        duration: 2000
      });
    });
  }
}
