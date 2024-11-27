//
//  CustomComponents.swift
//  GymTracker
//
//  Created by Viktor Nedanovski on 11/15/24.
//

import SwiftUI

struct ButtonTemplate: View {
    
    var txtColor: Color = .white
    var bgColor: Color = .green
    var text: String
    var iconName: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(text)
        }
        .foregroundStyle(txtColor)
        .font(.system(size: 20))
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(bgColor)
            )
        .padding()
    }
}
