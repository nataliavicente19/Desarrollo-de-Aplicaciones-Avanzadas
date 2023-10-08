//
//  ContentView.swift
//  DAA4
//
//  Created by nati on 6/10/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var users: [Users]
    
    @State private var isAddingUser = false
    @State private var name:String = ""
    @State private var surname:String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                List(users){ user in
                    VStack(alignment: .leading){
                        Text(user.name)
                        Text(user.surname)
                    }
                }
                Button("Add User"){
                    isAddingUser = true
                }
                .sheet(isPresented: $isAddingUser){
                    VStack{
                        TextField("Name", text: $name)
                            .padding()
                            .border(Color.gray)
                        TextField("Surname", text: $surname)
                            .padding()
                            .border(Color.gray)
                        Button("Save"){
                            users.append(Users(name: name, surname: surname))
                            isAddingUser = false
                        }
                    }
                }
            }
        }
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
