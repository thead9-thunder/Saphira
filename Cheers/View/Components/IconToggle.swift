//
//  IconToggle.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import SwiftUI

struct IconToggle: View {
    let label: String
    let onIcon: String
    let offIcon: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Spacer()
            Label {
                Text(label)
            } icon: {
                Image(systemName: isOn ? onIcon : offIcon)
                    .animation(.smooth, value: isOn)
                    .symbolEffect(.bounce, value: isOn)
            }
            Spacer()
        }
        .toggleStyle(.button)
        .gridCellAnchor(.center)
    }
} 
