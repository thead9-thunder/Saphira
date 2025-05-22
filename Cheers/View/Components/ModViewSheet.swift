import SwiftUI

struct ModViewSheet<Mode: Identifiable, SheetContent: View>: ViewModifier {
    @Binding var activeSheet: Mode?
    let modContent: (Mode) -> SheetContent

    func body(content: Content) -> some View {
        content
            .sheet(item: $activeSheet) { mode in
                NavigationStack {
                    self.modContent(mode)
                }
            }
    }
}

// MARK: - Generic Modifier
extension View {
    func modSheet<Mode: Identifiable, Content: View>(
        activeSheet: Binding<Mode?>,
        @ViewBuilder content: @escaping (Mode) -> Content
    ) -> some View {
        modifier(ModViewSheet(activeSheet: activeSheet, modContent: content))
    }
}
