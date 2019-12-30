import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { Component, OnInit, Inject } from '@angular/core';

@Component({
  selector: 'app-prompt-dialog',
  templateUrl: './prompt-dialog.component.html',
  styleUrls: ['./prompt-dialog.component.scss']
})
export class PromptDialogComponent implements OnInit {
  title: string;
  message = '';

  constructor(
    public dialogRef: MatDialogRef<PromptDialogComponent, string>,
    @Inject(MAT_DIALOG_DATA) public data: PromptDialogModel
  ) {
    // Update view with given values
    this.title = data.title;
  }

  ngOnInit() {
  }

  onPrompt(): void {
    // Close the dialog, return true
    this.dialogRef.close(this.message);
  }

  onDismiss(): void {
    // Close the dialog, return false
    this.dialogRef.close(this.message);
  }
}

/**
 * Class to represent prompt dialog model.
 *
 * It has been kept here to keep it as part of shared component.
 */
export class PromptDialogModel {

  constructor(public title: string) {
  }
}
