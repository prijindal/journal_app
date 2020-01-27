import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { JournalTextareaComponent } from './journal-textarea.component';
import { AppMaterialModule } from '../app-material/app-material.module';

describe('JournalTextareaComponent', () => {
  let component: JournalTextareaComponent;
  let fixture: ComponentFixture<JournalTextareaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ JournalTextareaComponent ],
      imports: [AppMaterialModule]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(JournalTextareaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
