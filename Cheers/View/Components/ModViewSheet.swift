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

// MARK: - Type-Specific Modifiers
extension View {
    func cabinetModSheet(activeSheet: Binding<CabinetModView.Mode?>, onCommit: @escaping (Cabinet) -> Void = { _ in }) -> some View {
        modSheet(activeSheet: activeSheet) { mode in
            CabinetModView(mode: mode, onCommit: onCommit)
        }
    }
    
    func shelfModSheet(activeSheet: Binding<ShelfModView.Mode?>, onCommit: @escaping (Shelf) -> Void = { _ in }) -> some View {
        modSheet(activeSheet: activeSheet) { mode in
            ShelfModView(mode: mode, onCommit: onCommit)
        }
    }
    
    func drinkModSheet(activeSheet: Binding<DrinkModView.Mode?>) -> some View {
        modSheet(activeSheet: activeSheet) { mode in
            DrinkModView(mode: mode)
        }
    }
    
    func brandModSheet(activeSheet: Binding<BrandModView.Mode?>, onCommit: @escaping (Brand) -> Void = { _ in }) -> some View {
        modSheet(activeSheet: activeSheet) { mode in
            BrandModView(mode: mode, onCommit: onCommit)
        }
    }
} 
