//
//  GradientButton.swift
//  InboxGuard
//
//  Created by Seher Kapan on 17.08.2024.
//

import SwiftUI

struct GradientButton: View {
    var onClick: () -> ()
    var title: String
    var icon : String
    
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15){
                Text(title)
                Image(systemName: icon)
            }
            .padding(.vertical,12)
            .padding(.horizontal, 35)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .background(.linearGradient(colors: [.green, .mint, .teal, .cyan, .blue], startPoint: .top, endPoint: .bottom), in: .buttonBorder)
            
        })
    }
}

