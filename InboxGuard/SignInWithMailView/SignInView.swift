//
//  ContentView.swift
//  InboxGuard
//
//  Created by Seher Kapan on 6.08.2024.
//

import SwiftUI

struct SignInView: View {
    @AppStorage("showSignup") private var showSignup: Bool = false
    @AppStorage("forgotPassword") private var forgotPassword : Bool = false 
    @AppStorage("log_status_signIn") private var logStatusSI: Bool = false
    
    
    var body: some View {
        NavigationStack{
            SignInWithEmail()
                .navigationDestination(isPresented: $logStatusSI){
                    Home()
                }
                .navigationDestination(isPresented: $showSignup){
                    SignUpPage()
                }

        }.overlay{
            if #available(iOS 17, *){
                CircleView()
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup || logStatusSI )
            }else{
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSignup || logStatusSI)
            }
        }
    }
    @ViewBuilder
    func CircleView() -> some View{
        Circle()
            .fill(.linearGradient(colors: [.green, .mint, .teal, .cyan, .blue], startPoint: .top, endPoint: .bottom))
            .frame(width:200 ,height:200)
            .hSpacing(showSignup || logStatusSI ? .trailing : .leading)
            .vSpacing(.top)
            .offset(x: showSignup || logStatusSI ? 90 : -90 ,y: -90)
            .blur(radius: 15)
    }
}
#Preview {
    SignInView()
}

