//
//  IconViews.swift
//  Cheers
//
//  Created by Thomas Headley on 6/25/25.
//

import SwiftUI

struct IconView: View {
    let icon: Icon
    
    var body: some View {
        switch icon {
        case .emoji(let emoji):
            Text(emoji)
        case .sfSymbol(let sfSymbol):
            Image(systemName: sfSymbol)
        case .customSFSymbol(let customSFSymbol):
            Image(customSFSymbol)
        }
    }
}

struct IconLabel<LabelContent: View>: View {
    let labelContent: LabelContent
    let icon: Icon
    
    init(_ titleKey: String, icon: Icon) where LabelContent == Text {
        self.labelContent = Text(titleKey)
        self.icon = icon
    }
    
    init(@ViewBuilder label: () -> LabelContent, icon: Icon) {
        self.labelContent = label()
        self.icon = icon
    }
    
    var body: some View {
        Label {
            labelContent
        } icon: {
            IconView(icon: icon)
        }
    }
}
