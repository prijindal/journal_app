import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { JournalListComponent } from './journal-list.component';
import { AppMaterialModule } from '../app-material/app-material.module';
import { AppRoutingModule } from '../app-routing.module';
import { HomeComponent } from '../home/home.component';
import { SettingsComponent } from '../settings/settings.component';
import { EditJournalComponent } from '../edit-journal/edit-journal.component';
import { JournalTextareaComponent } from '../journal-textarea/journal-textarea.component';
import { JournalService } from '../journal.service';
import { MockJournalService } from '../journal.service.mock';

describe('JournalListComponent', () => {
  let component: JournalListComponent;
  let fixture: ComponentFixture<JournalListComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ JournalListComponent, HomeComponent, SettingsComponent, EditJournalComponent, JournalTextareaComponent ],
      imports: [AppMaterialModule, AppRoutingModule],
      providers: [{
        provide: JournalService, useClass: MockJournalService
      }]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(JournalListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
