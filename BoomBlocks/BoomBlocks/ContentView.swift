//
//  ContentView.swift
//  BoomBlocks
//
//  Created by Pjcyber on 6/6/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userAuth: UserAuthService
    
    var body: some View {
        VStack {
            NavigationView {
                // if  !userAuth.isLoggedin {
                //LoginView()
                //} else {
                  BlocksBackgroundView()
                // }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
