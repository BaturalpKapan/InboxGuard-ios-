//
//  SignInWithEmail.swift
//  InboxGuard
//
//  Created by Seher Kapan on 15.08.2024.
//

import SwiftUI
import FirebaseAuth
import Lottie

struct SignInWithEmail: View {
    @State private var emailAdress: String = ""
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State var loginPressed: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = true
    @State private var isLoading: Bool = false
    @State private var showEmailVerificationView:Bool = true
    @AppStorage("log_status_signIn") private var logStatusSI: Bool = false
    @AppStorage("reset_View")  private var showResetView: Bool = false
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @AppStorage("forgotPassword") private var forgotPassword : Bool = false 
    @AppStorage("log_status") private var logStatus: Bool = false
    @AppStorage("reset_email_sent_View") private var resetEmailSent: Bool = true
    
    var body: some View {
        Button(action: {showSigninE.toggle()}, label :{
            Image(systemName: "arrow.left")
                .font(.title2)
                .foregroundStyle(.gray)
                .padding(.leading)
                .position(x:20, y:245)
                
        })
        Spacer(minLength: 0)
        VStack(alignment: .leading, spacing: 15, content:{
            Spacer(minLength: 2)

            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                //Custom text fields
                CustomTextField(sfIcon: "at", hint: "Your email", value: $emailAdress)
                    .autocapitalization(.none)
                CustomTextField(sfIcon: "lock", hint: "Password",isPassword: true, value: $password).autocapitalization(.none)
                    .padding(.top, 5)
                Button("Forgot Password?"){
                    forgotPassword.toggle()
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.teal)
                .hSpacing(.trailing)
                GradientButton(onClick: {
                    loginPressed.toggle()
                    print(loginPressed)
                    loginAndSignUp()
                                        }, title: "Login", icon: "arrow.right")
                    .disavleWithOpacity(emailAdress.isEmpty || password.isEmpty)
            }//Vstack
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            HStack(spacing:6){
                Text("Don't have an account?")
                Button("Sign Up?"){
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .tint(.teal)
            }
            .font(.callout)
            .hSpacing()
        })
        .hSpacing(.top)//content
        .padding(.vertical)
        .padding(.horizontal)
        .padding(.top, -275)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $forgotPassword, content: {
            if #available(iOS 16.4, *){
                ForgotPassword()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            }else{
                ForgotPassword()
                    .presentationDetents([.height(350)])
            }
        })
      
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *){
                resetPasswordView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            }else{
                resetPasswordView()
                    .presentationDetents([.height(350)])
            }
        })
        .sheet(isPresented: $resetEmailSent, content: {
            if #available(iOS 16.4, *){
                emailVerificationView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            }else{
                emailVerificationView()
                    .presentationDetents([.height(350)])
            }
        })

        
        
    }// body
    
    //Email verification view
    @ViewBuilder
    func emailVerificationView() -> some View{
        VStack(spacing: 6){
            GeometryReader{_ in
                if let bundle = Bundle.main.path(forResource: "animation2", ofType: "json"){
                    LottieView{
                        await LottieAnimation.loadedFrom(url: URL(filePath: bundle))
                    }
                    .playing(loopMode: .loop)
                }
            }
            Text("Verification")
                .font(.title.bold())
            Text("We have sent a reset email to your email address. \nPlease continue to your email to reset your password.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 25)
        }.overlay(alignment: .topTrailing, content:{
            Button("Cancel"){
                resetEmailSent = false
                isLoading = false
            }.padding(15)
        })
        .padding(.bottom,15)
    }
    func loginAndSignUp(){
        Task{
            isLoading = true
            do{
                if loginPressed{
                    let result = try await Auth.auth().signIn(withEmail: emailAdress, password: password)
                    if result.user.isEmailVerified{
                        //verified user redirect to home view
                        //logStatus = true
                        logStatusSI = true
                    }else{
                        //not verified user verify first then redirect to home view
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }
                }else{
                    //creating new account
                    if password == rePassword{
                        let result = try await Auth.auth().createUser(withEmail: emailAdress, password: password)
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }else{
                        await presentingAlert("Mismatching passwords!")
                    }
                }
            }catch{
                await presentingAlert(error.localizedDescription)
            }
        }
    }
    
    func presentingAlert(_ message: String) async{
        await MainActor.run{
            alertMessage = message
            showAlert = true
            isLoading = false
        }
    }
}



#Preview {
   SignInView()
}
