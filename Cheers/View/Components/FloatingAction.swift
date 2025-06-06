import SwiftUI

enum FloatingActionStyle {
    case icon(systemName: String)
    case label(title: String, systemImage: String)
}

enum FloatingActionType {
    case button(() -> Void)
    case menu([FloatingMenuItem])
}

enum FloatingActionPosition {
    case bottomLeft
    case bottomCenter
    case bottomRight
}

struct FloatingMenuItem {
    let title: String
    let systemImageName: String
    let action: () -> Void
}

struct FloatingActionModifier: ViewModifier {
    let style: FloatingActionStyle
    let type: FloatingActionType
    let position: FloatingActionPosition

    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content

            VStack {
                Spacer()
                HStack {
                    if position == .bottomLeft {
                        actionButton
                        Spacer()
                    } else if position == .bottomCenter {
                        Spacer()
                        actionButton
                        Spacer()
                    } else if position == .bottomRight {
                        Spacer()
                        actionButton
                    }
                }
                .padding([.horizontal, .bottom], 16)
            }
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        switch type {
        case .button(let action):
            Button(action: action) {
                buttonContent
            }
            .buttonStyle(.borderedProminent)
            .shadow(radius: 4)
            
        case .menu(let items):
            Menu {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    Button(action: item.action) {
                        Label(item.title, systemImage: item.systemImageName)
                    }
                }
            } label: {
                Button {
                    // Empty action as the menu handles the interaction
                } label: {
                    buttonContent
                }
                .buttonStyle(.borderedProminent)
                .shadow(radius: 4)
            }
        }
    }

    @ViewBuilder
    private var buttonContent: some View {
        switch style {
        case .icon(let systemName):
            Image(systemName: systemName)
        case .label(let title, let systemImage):
            Label(title, systemImage: systemImage)
        }
    }
}

extension View {
    // Single button with icon
    func floatingAction(
        systemImage: String,
        position: FloatingActionPosition = .bottomCenter,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(FloatingActionModifier(
            style: .icon(systemName: systemImage),
            type: .button(action),
            position: position
        ))
    }

    // Single button with label
    func floatingAction(
        title: String,
        systemImage: String,
        position: FloatingActionPosition = .bottomCenter,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(FloatingActionModifier(
            style: .label(title: title, systemImage: systemImage),
            type: .button(action),
            position: position
        ))
    }

    // Menu with icon
    func floatingAction(
        systemImage: String,
        menuItems: [FloatingMenuItem],
        position: FloatingActionPosition = .bottomCenter
    ) -> some View {
        self.modifier(FloatingActionModifier(
            style: .icon(systemName: systemImage),
            type: .menu(menuItems),
            position: position
        ))
    }

    // Menu with label
    func floatingAction(
        title: String,
        systemImage: String,
        menuItems: [FloatingMenuItem],
        position: FloatingActionPosition = .bottomCenter
    ) -> some View {
        self.modifier(FloatingActionModifier(
            style: .label(title: title, systemImage: systemImage),
            type: .menu(menuItems),
            position: position
        ))
    }
} 
