//
//  ModViewSheet.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import SwiftUI

struct ModViewSheet<Mode: Identifiable, SheetContent: View>: ViewModifier {
    @Binding var activeSheet: Mode?
    let modContent: (Mode) -> SheetContent
    let detents: Set<PresentationDetent>
    
    init(
        activeSheet: Binding<Mode?>,
        detents: Set<PresentationDetent> = [.large],
        @ViewBuilder modContent: @escaping (Mode) -> SheetContent
    ) {
        self._activeSheet = activeSheet
        self.detents = detents
        self.modContent = modContent
    }

    func body(content: Content) -> some View {
        content
            .sheet(item: $activeSheet) { mode in
                NavigationStack {
                    self.modContent(mode)
                }
                .presentationDetents(detents)
            }
    }
}

// MARK: - Generic Modifier
extension View {
    func modSheet<Mode: Identifiable, Content: View>(
        activeSheet: Binding<Mode?>,
        detents: Set<PresentationDetent> = [.large],
        @ViewBuilder content: @escaping (Mode) -> Content
    ) -> some View {
        modifier(ModViewSheet(activeSheet: activeSheet, detents: detents, modContent: content))
    }
}
