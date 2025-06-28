//
//  SelectableBackground.swift
//  Cheers
//
//  Created by Thomas Headley on 6/28/25.
//

import SwiftUI

struct SelectableBackground: ViewModifier {
    let isSelected: Bool
    let cornerRadius: CGFloat
    
    init(isSelected: Bool, cornerRadius: CGFloat = 8) {
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
                    )
            )
    }
}

extension View {
    func selectableBackground(isSelected: Bool, cornerRadius: CGFloat = 8) -> some View {
        modifier(SelectableBackground(isSelected: isSelected, cornerRadius: cornerRadius))
    }
} 