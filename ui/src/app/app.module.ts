import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { HomeComponent } from './home/home.component';
import { SettingsComponent } from './settings/settings.component';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { ConfirmDialogComponent } from './confirm-dialog/confirm-dialog.component';
import { EditJournalComponent } from './edit-journal/edit-journal.component';
import { JournalListComponent } from './journal-list/journal-list.component';
import { JournalTextareaComponent } from './journal-textarea/journal-textarea.component';
import { EncryptionKeyModalComponent } from './encryption-key-modal/encryption-key-modal.component';
import { AppMaterialModule } from './app-material/app-material.module';

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
    EncryptionKeyModalComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    AppMaterialModule
  ],
  entryComponents: [
    ConfirmDialogComponent,
    EncryptionKeyModalComponent
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
