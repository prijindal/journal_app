import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HomeComponent } from './home.component';
import { AppMaterialModule } from '../app-material/app-material.module';
import { EditJournalComponent } from '../edit-journal/edit-journal.component';
import { JournalTextareaComponent } from '../journal-textarea/journal-textarea.component';
import { JournalListComponent } from '../journal-list/journal-list.component';
import { AppRoutingModule } from '../app-routing.module';
import { SettingsComponent } from '../settings/settings.component';
import { JournalService } from '../journal.service';
import { MockJournalService } from '../journal.service.mock';

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HomeComponent, EditJournalComponent, JournalTextareaComponent, JournalListComponent, SettingsComponent ],
      imports: [AppMaterialModule, AppRoutingModule],
      providers: [{
        provide: JournalService, useClass: MockJournalService
      }]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
