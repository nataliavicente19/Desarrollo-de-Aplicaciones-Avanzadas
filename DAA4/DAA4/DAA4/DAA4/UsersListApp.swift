//
//  UserListApp.swift
//  DAA4
//
//  Created by nati on 6/10/23.
//

import SwiftUI

struct Users: Identifiable {
    var id = UUID()
    var name:String
    var surname:String
}

class AppState: ObservableObject{
    @Published var isLoggedIn = false
    @Published var users: [Users] = []
}

@main
struct DAA4App: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            if(appState.isLoggedIn){
                ContentView(users: $appState.users)
            }else{
                LoginView(isLoggedIn: $appState.isLoggedIn)
            }
            
        }
    }
}
