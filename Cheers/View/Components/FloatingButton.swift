//
//  FloatingButton.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI

enum FloatingButtonPosition {
    case bottomLeft, bottomCenter, bottomRight

    var alignment: Alignment {
        switch self {
        case .bottomLeft: return .bottomLeading
        case .bottomCenter: return .bottom
        case .bottomRight: return .bottomTrailing
        }
    }
}

enum FloatingButtonStyle {
    case icon(systemName: String)
    case label(title: String, systemImage: String)
}

struct FloatingButtonModifier: ViewModifier {
    let style: FloatingButtonStyle
    let action: () -> Void
    let position: FloatingButtonPosition

    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content

            VStack {
                Spacer()
                HStack {
                    if position == .bottomLeft {
                        button
                        Spacer()
                    } else if position == .bottomCenter {
                        Spacer()
                        button
                        Spacer()
                    } else if position == .bottomRight {
                        Spacer()
                        button
                    }
                }
                .padding([.horizontal, .bottom], 16)
            }
        }
    }

    private var button: some View {
        Button(action: action) {
            buttonContent
        }
    }

    @ViewBuilder
    private var buttonContent: some View {
        switch style {
        case .icon(let systemName):
            Image(systemName: systemName)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(Color.accentColor))
                .shadow(radius: 4)

        case .label(let title, let systemImage):
            Label {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            } icon: {
                Image(systemName: systemImage)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
            .shadow(radius: 4)
        }
    }
}

extension View {
    func floatingButton(
        systemImageName: String,
        position: FloatingButtonPosition = .bottomRight,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(FloatingButtonModifier(style: .icon(systemName: systemImageName), action: action, position: position))
    }

    func floatingButton(
        label: String,
        systemImage: String,
        position: FloatingButtonPosition = .bottomRight,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(FloatingButtonModifier(style: .label(title: label, systemImage: systemImage), action: action, position: position))
    }
}
