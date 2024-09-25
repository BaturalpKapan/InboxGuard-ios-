//
//  CustomTextField.swift
//  InboxGuard
//
//  Created by Seher Kapan on 15.08.2024.
//

import SwiftUI

struct CustomTextField: View {
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    var isPassword: Bool = false
    @Binding var value: String
    //view properties
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @State private var showPassword: Bool = false
    var body: some View {
        HStack(alignment: .top,spacing: 8, content: {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y:2)
            
            VStack(alignment: .leading, spacing: 8, content: {
                if isPassword{
                    if showPassword{
                        TextField(hint, text: $value)
                    }else{
                        SecureField(hint, text: $value)
                    }
                }else{
                    TextField(hint, text:$value)
                }
                Divider()
            })//Vstack
            .overlay(alignment: .trailing){
                //Password reveal button
                if isPassword{
                    Button(action: {
                        withAnimation{
                            showPassword.toggle()
                        }
                    }, label:{
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })//button
                }
            }//overlay
        })//Hstack
    }
}


