import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EncryptionKeyModalComponent } from './encryption-key-modal.component';
import { AppMaterialModule } from '../app-material/app-material.module';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

describe('EncryptionKeyModalComponent', () => {
  let component: EncryptionKeyModalComponent;
  let fixture: ComponentFixture<EncryptionKeyModalComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EncryptionKeyModalComponent ],
      imports: [AppMaterialModule],
      providers: [
        { provide: MatDialogRef, useValue: {} },
        { provide: MAT_DIALOG_DATA, useValue: [] },
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EncryptionKeyModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
