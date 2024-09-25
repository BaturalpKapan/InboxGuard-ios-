//
//  GoogleSignIn_VM.swift
//  InboxGuard
//
//  Created by Seher Kapan on 13.08.2024.
//

import FirebaseAuth
import Firebase
import GoogleSignIn
import SwiftUI


class GoogleSignIn_VM: ObservableObject {
    @AppStorage("log_status") private var logStatus: Bool = false
    @Published var isLoginSuccessed = false
    func SignInWGoogle(){
        // get app client id
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        // create oogle sign in configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // sign in method goes here
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            self.logStatus = true
            guard
                let user = user?.user,
                let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {res, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let user = res?.user else { return }
                print(user)
            }
            
        }
        
    }
}
