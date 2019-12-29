import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatIconModule } from '@angular/material/icon';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatListModule } from '@angular/material/list';
import { MatDialogModule } from '@angular/material/dialog';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatCheckboxModule} from '@angular/material/checkbox';
import { FormsModule } from '@angular/forms';

import { HomeComponent } from './home/home.component';
import { SettingsComponent } from './settings/settings.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { ConfirmDialogComponent } from './confirm-dialog/confirm-dialog.component';
import { EditJournalComponent } from './edit-journal/edit-journal.component';
import { JournalListComponent } from './journal-list/journal-list.component';
import { JournalTextareaComponent } from './journal-textarea/journal-textarea.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    SettingsComponent,
    ToolbarComponent,
    ConfirmDialogComponent,
    EditJournalComponent,
    JournalListComponent,
    JournalTextareaComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    BrowserAnimationsModule,
    FormsModule,
    MatIconModule,
    MatToolbarModule,
    MatButtonModule,
    MatListModule,
    MatDialogModule,
    MatSnackBarModule,
    MatCheckboxModule
  ],
  entryComponents: [ConfirmDialogComponent],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
