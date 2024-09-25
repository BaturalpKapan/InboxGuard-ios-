//
//  LoginView.swift
//  InboxGuard
//
//  Created by Seher Kapan on 4.09.2024.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("log_status_signIn") private var logStatusSI: Bool = false
    @AppStorage("showSigninE") private var showSigninE: Bool = false
    @AppStorage("showSignup") private var showSignup: Bool = false
    
    var body: some View {
        NavigationStack{
            LoginPage()
                .navigationDestination(isPresented: $showSigninE ){
                    SignInWithEmail()
                        .navigationDestination(isPresented: $logStatusSI){
                            Home()
                    }
                        .navigationDestination(isPresented:$showSignup){
                            SignUpPage()
                        }
                }
        }.overlay{
            if #available(iOS 17, *){
                CircleView()
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSigninE || logStatusSI ? (showSigninE || logStatusSI) && !(showSigninE && logStatusSI) : showSigninE || logStatusSI)
            }else{
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSigninE || logStatusSI)
            }
        }
    }
    
    @ViewBuilder
    func CircleView() -> some View{
        Circle()
        
        
            .fill(.linearGradient(colors: [.green, .mint, .teal, .cyan, .blue], startPoint: .top, endPoint: .bottom))
            .frame(width:200 ,height:200)
            .hSpacing(showSigninE || logStatusSI ? showSigninE && logStatusSI ? .trailing : .leading : .trailing)
            .vSpacing(.top)
            .offset(x: showSigninE || logStatusSI ? showSigninE && logStatusSI ? 90 : -90 : 90 ,y: -90)
            .blur(radius: 15)
    }
}

#Preview {
    LoginView()
}
