//
//  Home.swift
//  InboxGuard
//
//  Created by Seher Kapan on 10.08.2024.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    @AppStorage("log_status_signIn") private var logStatusSI: Bool = false
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationStack{
            Button("Log_out"){
                try? Auth.auth().signOut()
                logStatusSI = false
                logStatus = false
            }
            .navigationTitle("Home")
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Home()
}
