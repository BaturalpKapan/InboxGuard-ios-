//
//  InboxGuardApp.swift
//  InboxGuard
//
//  Created by Seher Kapan on 6.08.2024.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
 struct InboxGuardApp: App {
    @AppStorage("log_status") private var logStatus: Bool = false
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @AppStorage("forgotPassword") private var forgotPassword : Bool = false 
    @AppStorage("reset_View") private var showResetView: Bool = false
    @AppStorage("reset_email_sent_View") private var resetEmailSent: Bool = false
    @AppStorage("log_status_signIn") private var logStatusSI: Bool = false
   

    init(){
        FirebaseApp.configure()
        showSignup = false
        showSigninE = false
        forgotPassword = false
        showResetView = false
        resetEmailSent = false
        logStatusSI = false 
    }
    
    var body: some Scene {
        WindowGroup {
            if logStatus {
                Home()
            }else{
                LoginView()
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey :Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

