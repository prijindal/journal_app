import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import {MatSnackBar} from '@angular/material/snack-bar';
import {JournalService} from '../journal.service';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';

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

  getJournalContent() {
    const journals = this.journalService.journalResponse.journals.filter((a) => a.id === this.journalId);
    if (journals.length > 0) {
      this.content = journals[0].content;
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
    this.journalService.editJournal(this.journalId, newContent)
    .then((data) => {
      this.journalId = null;
      this.snackBar.open(`Succesfully edited journal ${data.id}`, 'Undo', {
        duration: 2000
      });
    });
  }
}
