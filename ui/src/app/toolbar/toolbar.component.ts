import { Component, OnInit } from '@angular/core';
import {protobufs} from '../../protobufs';

import { UserService } from '../user.service';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent implements OnInit {
  public user: protobufs.User;
  constructor(private userService: UserService) { }

  ngOnInit() {
    this.userService.getUser()
    .then((user) => {
      this.user = user;
    });
  }

}
