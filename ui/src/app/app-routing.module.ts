import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { HomeComponent } from './home/home.component';
import { SettingsComponent } from './settings/settings.component';
import { EditJournalComponent } from './edit-journal/edit-journal.component';
import { JournalListComponent } from './journal-list/journal-list.component';

const routes: Routes = [{
  path: '',
  component: HomeComponent
}, {
  path: 'settings',
  component: SettingsComponent
}, {
  path: 'journal',
  component: JournalListComponent
}, {
  path: 'journal/:id',
  component: EditJournalComponent
}];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
