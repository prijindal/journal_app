import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { HomeComponent } from './home/home.component';
import { SettingsComponent } from './settings/settings.component';
import { EditJournalComponent } from './edit-journal/edit-journal.component';

const routes: Routes = [{
  path: '',
  component: HomeComponent
}, {
  path: 'settings',
  component: SettingsComponent
}, {
  path: 'journal/:id',
  component: EditJournalComponent
}];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
