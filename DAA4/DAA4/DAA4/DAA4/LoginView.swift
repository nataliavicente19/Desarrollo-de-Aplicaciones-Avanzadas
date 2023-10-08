//
//  LoginView.swift
//  DAA4
//
//  Created by nati on 6/10/23.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var correctUsername = "Admin"
    var correctPassword = "1234"
    
    var body: some View {
        VStack{
            TextField(
                "Usuario",
                text: $username
            ).border(Color.gray)
            .padding()
            SecureField(
                "Contraseña",
                text: $password
            ).border(Color.gray)
            .padding()
            Button("Login"){
                if username == correctUsername && password == correctPassword{
                    isLoggedIn = true
                }
            }
        } .padding()
    }
}
/*
struct LoginView_Previews: PreviewProvider {
    @State static var sampleLogin:Bool = false
    static var previews: some View {
        LoginView(isLoggedIn: $sampleLogin)
    }
}*/
