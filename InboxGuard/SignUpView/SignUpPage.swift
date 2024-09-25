//
//  SignUpView.swift
//  InboxGuard
//
//  Created by Seher Kapan on 18.08.2024.
//

import SwiftUI
import Lottie
import FirebaseAuth

struct SignUpPage: View {
    @State private var emailAdress: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = true
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State private var Full_Name: String = ""
    @State private var isLoading: Bool = false
    @State var loginPressed: Bool = false
    @State private var showEmailVerificationView: Bool = false
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @AppStorage("log_status") private var logStatus: Bool = false
    
    
    var body: some View {
        Spacer(minLength: 20)
        
        VStack(alignment: .leading, spacing: 15, content:{
            Button(action: {showSignup.toggle()}, label :{
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            Spacer(minLength: 50)
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Please sign up to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                
                //Custom text fields
                CustomTextField(sfIcon: "person", hint: "Full Name", value: $Full_Name)
                    .autocapitalization(.none)
                CustomTextField(sfIcon: "at", hint: "Your email", value: $emailAdress)
                    .autocapitalization(.none)
                CustomTextField(sfIcon: "lock", hint: "Password",isPassword: true, value: $password).autocapitalization(.none)
                CustomTextField(sfIcon: "lock", hint: "re-Password",isPassword: true, value: $rePassword).autocapitalization(.none)
                
                GradientButton(onClick: {loginAndSignUp()}, title: "Sign Up", icon: "arrow.right")
                    .disavleWithOpacity(emailAdress.isEmpty || password.isEmpty || rePassword.isEmpty || Full_Name.isEmpty)
            }//Vstack
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            HStack(spacing:6){
                Text("Already have an account?")
                Button("Sign In?"){
                    showSignup.toggle()
                    print(showSignup)
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
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showEmailVerificationView, content: {
            emailVerificationView()
                .presentationDetents([.height(350)])
                .presentationCornerRadius(30)
                .interactiveDismissDisabled()
        })
        
        
    }
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
            Text("We have sent a verification email to your email address. \nPlease verify to continue.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 25)
        }.overlay(alignment: .topTrailing, content:{
            Button("Cancel"){
                showEmailVerificationView = false
                isLoading = false
            }.padding(15)
        })
        .padding(.bottom,15)
        .onReceive(Timer.publish(every: 2, on: .main, in: .default), perform: { _ in
            if let user = Auth.auth().currentUser{
                user.reload()
                if user.isEmailVerified{
                    showEmailVerificationView = false
                    logStatus = true
                }
            }
        })
    }
    
    func loginAndSignUp(){
        Task{
            isLoading = true
            do{
                if loginPressed{
                    let result = try await Auth.auth().signIn(withEmail: emailAdress, password: password)
                    if result.user.isEmailVerified{
                        //verified user redirect to home view
                        logStatus = true
                    }else{
                        //not verified user verify first then redirect to home view
                        try await result.user.sendEmailVerification()
                        showEmailVerificationView = true
                    }
                }else{
                    //creating new account
                    print("yessir yessir")
                    if password == rePassword{
                        print("selamın aleykğm gardas")
                        let result = try await Auth.auth().createUser(withEmail: emailAdress, password: password)
                        do {
                            try await result.user.sendEmailVerification()
                            showEmailVerificationView = true
                            print("Email verification sent")
                        } catch {
                            print("Failed to send email verification: \(error.localizedDescription)")
                        }
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
