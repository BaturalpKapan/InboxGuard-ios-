//
//  resetPassword.swift
//  InboxGuard
//
//  Created by Seher Kapan on 18.08.2024.
//

import SwiftUI
struct resetPasswordView: View {
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    //Environment properties
    @Environment(\.dismiss) private var dismiss
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @AppStorage("forgotPassword") private var forgotPassword : Bool = false
    
    var body: some View {
        Spacer(minLength: 50)

        VStack(alignment: .leading, spacing: 15, content:{
            Button(action: {dismiss()}, label :{
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            Spacer(minLength: 50)
                Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            VStack(spacing: 25){
                
                //Custom text fields
                CustomTextField(sfIcon: "lock", hint: "Password", value: $password)
                    .autocapitalization(.none)
                CustomTextField(sfIcon: "lock", hint: "Confirm Password", value: $confirmPassword)
                    .autocapitalization(.none)
                GradientButton(onClick: {dismiss()}, title: "Send Link", icon: "arrow.right")
                    .disavleWithOpacity(password.isEmpty || confirmPassword.isEmpty)
            }//Vstack

        })
        .hSpacing(.top)//content
        .padding(.vertical)
        .padding(.horizontal)
        .interactiveDismissDisabled()
        
    }
}

#Preview {
 resetPasswordView()
}


