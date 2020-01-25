import { Component, OnInit } from '@angular/core';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';
import { Router } from '@angular/router';

import {JournalService} from '../journal.service';
import {SavetypeService} from '../savetype.service';
import {EncryptionService} from '../encryption.service';
import { MatSnackBar, MatDialog } from '@angular/material';
import { protobufs } from 'src/protobufs';
import { enterKeyModalAndSave } from '../encryption-key-modal/encryption-key-modal.component';

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
  public isHandset: boolean;
  public content = '';
  constructor(
    private snackBar: MatSnackBar,
    private journalService: JournalService,
    private savetypeService: SavetypeService,
    private encryptionService: EncryptionService,
    private dialog: MatDialog,
    private router: Router,
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
    this.journalService.getJournals();
  }

  async addJournal(newContent: string) {
    const saveType = this.savetypeService.getSaveType();
    if (saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
      if (this.encryptionService.getEncryptionKey() == null) {
        await enterKeyModalAndSave(this.dialog, this.encryptionService);
      }
      newContent = this.encryptionService.encrypt(newContent);
    }
    this.journalService.addJournal(newContent, saveType)
    .then((data) => {
      this.snackBar.open(`Succesfully added journal ${data.id}`, 'Undo', {
        duration: 2000
      });
      this.router.navigate(['/journal', data.id]);
      this.content = '';
    });
  }
}
