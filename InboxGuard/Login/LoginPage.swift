//
//  File.swift
//  InboxGuard
//
//  Created by Seher Kapan on 7.08.2024.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

struct LoginPage: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    @AppStorage("log_status") private var logStatus: Bool = false
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @StateObject private var vm = GoogleSignIn_VM()
   
    
    
    var body: some View {
        NavigationView {  // NavigationView ekliyoruz
            ZStack {
                    Text("")
                        .mask {
                            Rectangle()
                                .fill(.linearGradient(colors: [
                                    .white,
                                    .white,
                                    .white,
                                    .white.opacity(0.9),
                                    .clear,
                                    .clear,
                                ], startPoint: .top, endPoint: .bottom))
                        }.ignoresSafeArea()
                    ScrollView(.vertical,showsIndicators: false){
                        VStack(alignment: .leading, spacing: 15.0) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 25))
                                .foregroundColor(.indigo)
                                .padding(.top, 15.0)
                                .position(x:15, y:44)
                            (Text("Welcome,").foregroundColor(colorScheme == .dark ? .white : .black)
                            +
                             Text("\nLogin to continue").foregroundColor(.gray))
                            .font(.title).fontWeight(.semibold)
                            .lineSpacing(10.0)
                            .padding(.top, 20)
                            .padding(.trailing,15)
                            
                            
                            
                            // Sign in with email button
                            Button(action: {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showSigninE = true
                                }
                               // isLoading = true
                               // if isLoading {
                              //      LoadingScreen()
                              //  }
                            }) {
                                Text("")
                                    .foregroundColor(Color.black)
                                    .frame(height: 47)
                                    .frame(maxWidth: .infinity)
                                    .contentShape(Capsule())
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.green, .mint, .teal, .cyan, .blue]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                    .overlay {
                                        ZStack {
                                            HStack {
                                                Image("epng").resizable().frame(width: 20, height: 20)
                                                Text("Sign in with email")
                                            }.foregroundStyle(colorScheme == .dark ? .black : .white)
                                        }
                                    }
                                    .clipShape(Capsule())
                                    .frame(height: 47)
                                    .frame(width: 370)
                            }
                            // Sign in with google button
                            Button(action: { vm.SignInWGoogle() }) {
                                Text("")
                                    .frame(height: 47)
                                    .frame(maxWidth: .infinity)
                                    .contentShape(Capsule())
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.green, .mint, .teal, .cyan, .blue]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                    .overlay {
                                        ZStack {
                                            HStack {
                                                Image(systemName: "g.circle").resizable().frame(width: 16, height: 16)
                                                Text("Sign in with Google")
                                            }.foregroundStyle(colorScheme == .dark ? .black : .white)
                                        }
                                    }
                                    .clipShape(Capsule())
                                    .frame(height: 47)
                                    .frame(width: 370)
                            }
                            // Sign in with Apple Button
                            SignInWithAppleButton(.signIn) { request in
                                let nonce = randomNonceString()
                                self.nonce = nonce
                                request.requestedScopes = [.email, .fullName]
                                print(nonce)
                                request.nonce = sha256(nonce)
                                print(" here fing here ")
                            } onCompletion: { result in
                                print(" inşallah buraya giriyosundır gardeş")
                                switch result {
                                case .success(let auth):
                                    print(" buraya girmiyo herhalde")
                                    loginWithFirebase(auth)
                                    
                                case .failure(let error):
                                    print(" failure ")
                                    showErrors(error.localizedDescription)
                                }
                            }.clipShape(Capsule())
                            .frame(height: 47)
                            .frame(width: 370)
                            .signInWithAppleButtonStyle(colorScheme == .dark ? .whiteOutline : .black)
                            

                        }.padding(.horizontal)//vstack
                    }//scrollview
            }.alert(errorMessage, isPresented: $showAlert) {}
            .overlay {
                if isLoading {
                    LoadingScreen()
                }
            }
            .navigationTitle("InboxGuard") // Burada NavigationTitle ekliyoruz
        }
    } // end of UI
   // loading screen UI
    func LoadingScreen() -> some View{
        ZStack{
            Rectangle().fill(.ultraThinMaterial)
            ProgressView().frame(width:45 ,height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
        }
    }
    func showErrors(_ message: String){
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    func loginWithFirebase(_ auth: ASAuthorization){
            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                isLoading = true
                guard let nonce else {
                    showErrors("Invalid state: A login callback was received, but no login request was sent.")
                    return
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    showErrors("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    showErrors("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                // Initialize a Firebase credential, including the user's full name.
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error.localizedDescription)
                        return
                    }
                    // User is signed in to Firebase with Apple.
                    // ...
                    logStatus = true
                    isLoading = false
                }
            }
        
    }
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
#Preview {
   LoginView()
}
