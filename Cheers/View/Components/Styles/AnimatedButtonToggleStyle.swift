//
//  AnimatedButtonToggleStyle.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI

struct AnimatedButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            withAnimation(.smooth) {
                configuration.isOn.toggle()
            }
        }) {
            configuration.label
        }
        .tint(configuration.isOn ? .accentColor : .secondary)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(configuration.isOn ? Color.accentColor.opacity(0.05) : Color.clear)
        )
        .buttonStyle(.bordered)
    }
}
