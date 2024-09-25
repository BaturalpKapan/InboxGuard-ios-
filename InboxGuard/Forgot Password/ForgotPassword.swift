//
//  ForgotPassword.swift
//  InboxGuard
//
//  Created by Seher Kapan on 18.08.2024.
//

import SwiftUI
import FirebaseAuth

struct ForgotPassword: View {
    @State private var resetEmailAdress: String = ""
    //Environment properties
    @Environment(\.dismiss) private var dismiss
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = true
    @State private var isLoading: Bool = false
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @AppStorage("forgotPassword") private var forgotPassword : Bool = false
    @AppStorage("reset_View") private var showResetView: Bool = false
    @AppStorage("reset_email_sent_View") private var resetEmailSent: Bool = false
    
    var body: some View {
        Spacer(minLength: 50)

        VStack(alignment: .leading, spacing: 15, content:{
            Button(action: {dismiss()}, label :{
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }).padding(.top)
            Spacer(minLength: 25)
                Text("Forgot Password?")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Please enter your email so that we can send reset link.")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25){
                
                //Custom text fields
                CustomTextField(sfIcon: "at", hint: "Your email", value: $resetEmailAdress)
                    .autocapitalization(.none)
                GradientButton(onClick: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                sendResetLink()
                                    }
                   
                    // 0.2 saniye sonra dismiss() işlemini gerçekleştir
                }, title: "Send Link", icon: "arrow.right")
                .disavleWithOpacity(resetEmailAdress.isEmpty)
                
            }//Vstack

        })
        .hSpacing(.top)//content
        .padding(.vertical)
        .padding(.horizontal)
        .padding(.top, -45)
        .interactiveDismissDisabled()
        
    }
    
    func sendResetLink(){
        Task{
            do{
                if resetEmailAdress.isEmpty{
                    await presentingAlert("Please enter an email address.")
                    return
                }
                isLoading = true
                try await Auth.auth().sendPasswordReset(withEmail: resetEmailAdress)
                await presentingAlert("Please check your email inbox and follow the steps to reset our password. ")
                //kullanıcıya mail başarıyla gidiyor ben de bunu kullanıcıya gstermeliyim
                resetEmailAdress = ""
                resetEmailSent = true
                isLoading = false
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
            resetEmailAdress = ""
        }
    }
}

#Preview {
  SignInView()
}
