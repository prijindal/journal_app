import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditJournalComponent } from './edit-journal.component';
import { AppMaterialModule } from '../app-material/app-material.module';
import { JournalTextareaComponent } from '../journal-textarea/journal-textarea.component';
import { JournalListComponent } from '../journal-list/journal-list.component';
import { AppRoutingModule } from '../app-routing.module';
import { HomeComponent } from '../home/home.component';
import { SettingsComponent } from '../settings/settings.component';
import { JournalService } from '../journal.service';
import { MockJournalService } from '../journal.service.mock';

describe('EditJournalComponent', () => {
  let component: EditJournalComponent;
  let fixture: ComponentFixture<EditJournalComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditJournalComponent, JournalTextareaComponent, JournalListComponent, HomeComponent, SettingsComponent ],
      imports: [AppMaterialModule, AppRoutingModule],
      providers: [{
        provide: JournalService, useClass: MockJournalService
      }]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditJournalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
