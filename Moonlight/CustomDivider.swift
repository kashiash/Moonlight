//
//  CustomDivider.swift
//  Moonlight
//
//  Created by Jacek Kosinski U on 23/08/2024.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    CustomDivider()
}
