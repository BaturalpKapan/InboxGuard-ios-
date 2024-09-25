//
//  View+Extensions.swift
//  InboxGuard
//
//  Created by Seher Kapan on 15.08.2024.
//

import SwiftUI

extension View {
    //View Alignments
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    
    //Disable with Opacity
    @ViewBuilder
    func disavleWithOpacity(_ condition: Bool) -> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
}

