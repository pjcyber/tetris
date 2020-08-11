//
//  LoginView.swift
//  BoomBlocks
//
//  Created by Pjcyber on 6/7/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                LoginTitle()
                LogoImage()
                TextField("Username", text: $userName)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(CGFloat(5.0))
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                
                SecureField("Password", text: $password)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(5.0)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                
                NavigationLink(destination: BlocksBackgroundView()) {
                    LoginButtonContent()
                }
                Spacer()
                
            }.padding()
                .background(Color.black)
                .edgesIgnoringSafeArea([.top, .bottom])
            
        }
    }
}

struct LoginTitle : View {
    var body: some View {
        return Text("BoomBlocks!")
            .font(.largeTitle)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct LogoImage : View {
    var body: some View {
        return Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .padding(.bottom, 20)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("Play")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.blue)
            .cornerRadius(15.0)
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif

