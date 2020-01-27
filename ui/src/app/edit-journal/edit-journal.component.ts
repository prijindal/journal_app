import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import {MatSnackBar} from '@angular/material/snack-bar';
import {JournalService} from '../journal.service';
import {BreakpointObserver, Breakpoints} from '@angular/cdk/layout';
import { protobufs } from 'src/protobufs';
import { EncryptionService } from '../encryption.service';
import { enterKeyModalAndSave } from '../encryption-key-modal/encryption-key-modal.component';
import { MatDialog } from '@angular/material';

@Component({
  selector: 'app-edit-journal',
  templateUrl: './edit-journal.component.html',
  styleUrls: ['./edit-journal.component.scss']
})
export class EditJournalComponent implements OnInit {
  private journalId: number | Long | null = null;
  public content: string = '';
  public isHandset: boolean | undefined;
  constructor(
    private route: ActivatedRoute,
    private journalService: JournalService,
    private encryptionService: EncryptionService,
    private snackBar: MatSnackBar,
    private dialog: MatDialog,
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

  ngOnInit(): void {
    this.route.paramMap.subscribe((params: ParamMap) => {
      const id = params.get('id');
      if (id != null) {
        this.journalId = parseInt(id, 10);
        if (this.journalService.journalResponse == null) {
          this.journalService.getJournals().then(() => {
            this.getJournalContent();
          });
        } else {
          this.getJournalContent();
        }
      }
    });
  }

  getJournal(): protobufs.IJournal | undefined {
    if (this.journalService.journalResponse != null) {
      const journals = this.journalService.journalResponse.journals.filter((a) => a.id === this.journalId);
      if (journals.length > 0) {
        return journals[0];
      } else {
        return;
      }
    }
  }

  async getJournalContent(): Promise<void> {
    if (this.journalService.journalResponse != null) {
      const journals = this.journalService.journalResponse.journals.filter((a) => a.id === this.journalId);
      if (journals.length > 0) {
        const journal = journals[0];
        if (journal.content != null) {
          if (journal.saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
            if (this.encryptionService.isEncryptionKeyNotFound) {
              await enterKeyModalAndSave(this.dialog, this.encryptionService);
            }
            this.content = this.encryptionService.decrypt(journal.content);
          } else {
            this.content = journal.content;
          }
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
  }

  async editSubmitJournal(newContent: string): Promise<void> {
    const journal = this.getJournal();
    if (journal != null) {
      if (journal.saveType === protobufs.Journal.JournalSaveType.ENCRYPTED) {
        if (this.encryptionService.isEncryptionKeyNotFound) {
          await enterKeyModalAndSave(this.dialog, this.encryptionService);
        }
        newContent = this.encryptionService.encrypt(newContent);
      }
      this.journalService.editJournal(this.journalId, newContent, journal.saveType)
      .then((data) => {
        this.journalId = null;
        this.snackBar.open(`Succesfully edited journal ${data.id}`, 'Undo', {
          duration: 2000
        });
      });
    }
  }
}
