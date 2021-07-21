import { DebugElement } from '@angular/core';
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';

import { RrYesNoComponent } from './Rr-yes-no.component';

fdescribe('RrYesNoComponent', () => {
  let component: RrYesNoComponent;
  let fixture: ComponentFixture<RrYesNoComponent>;
  let debugElement: DebugElement;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [RrYesNoComponent]
    })
      .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RrYesNoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
    debugElement = fixture.debugElement;
  });


  it('UI Yes value is true exsits', () => {
    const debugBtn = debugElement.query(By.css('#btnYes'));
    const btn: HTMLElement = debugBtn.nativeElement;
    expect(btn.textContent.toString().trim()).toEqual('Yes');
  });

  it('UI No value is false exsits', () => {
    const debugBtn = debugElement.query(By.css('#btnNo'));
    const btn: HTMLElement = debugBtn.nativeElement;
    expect(btn.textContent.toString().trim()).toEqual('No');
  });

  it('check if writeValue cast boolean true toString', () => {
    // arrange
    let result: string = "true";
    let option: boolean = true;
    // act
    component.writeValue(option);
    // assert
    expect(result).toEqual(component.value)
  });

  it('check if writeValue cast boolean false toString', () => {
    // arrange
    let result: string = "false";
    let option: boolean = false;
    // act
    component.writeValue(option);
    // assert
    expect(result).toEqual(component.value)
  });

  it('check if writeValue cast boolean false FAILES toString', () => {
    // arrange
    let result: boolean = false;
    let option: boolean = false;
    // act
    component.writeValue(option);
    // assert
    expect(result).not.toEqual(component.value)
  });

});
