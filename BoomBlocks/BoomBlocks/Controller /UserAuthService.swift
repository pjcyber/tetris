//
//  UserAuthService.swift
//  BoomBlocks
//
//  Created by Pjcyber on 6/7/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Combine

class UserAuthService: ObservableObject {

  let didChange = PassthroughSubject<UserAuthService,Never>()
  let willChange = PassthroughSubject<UserAuthService,Never>()

  func login() {
    self.isLoggedin = true
  }

  var isLoggedin = false {
    didSet {
      didChange.send(self)
    }
  }
}

