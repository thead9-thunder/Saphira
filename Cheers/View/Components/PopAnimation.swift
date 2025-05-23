//
//  PopAnimation.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import SwiftUI

struct PopAnimation<Value: Equatable>: ViewModifier {
    let value: Value
    @State private var scale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onChange(of: value) { _, _ in
                scale = 1.2
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
    }
}

extension View {
    func popAnimation<Value: Equatable>(value: Value) -> some View {
        modifier(PopAnimation(value: value))
    }
} 