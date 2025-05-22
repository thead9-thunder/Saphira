import SwiftUI

struct FloatingMenuModifier: ViewModifier {
    let position: FloatingButtonPosition
    let menuLabelSystemImageName: String
    let menuItems: [MenuItem]

    struct MenuItem {
        let title: String
        let systemImageName: String
        let action: () -> Void
    }

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                Spacer()
                HStack {
                    if position == .bottomLeft {
                        menu
                        Spacer()
                    } else if position == .bottomCenter {
                        Spacer()
                        menu
                        Spacer()
                    } else if position == .bottomRight {
                        Spacer()
                        menu
                    }
                }
                .padding([.horizontal, .bottom], 16)
            }
        }
    }

    private var menu: some View {
        Menu {
            ForEach(menuItems.indices, id: \.self) { index in
                let item = menuItems[index]
                Button(action: item.action) {
                    Label(item.title, systemImage: item.systemImageName)
                }
            }
        } label: {
            Image(systemName: menuLabelSystemImageName)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(Color.accentColor))
                .shadow(radius: 4)
        }
    }
}

extension View {
    func floatingMenu(
        systemImageName: String,
        menuItems: [FloatingMenuModifier.MenuItem],
        position: FloatingButtonPosition = .bottomRight
    ) -> some View {
        self.modifier(FloatingMenuModifier(position: position, menuLabelSystemImageName: systemImageName, menuItems: menuItems))
    }
}
