//
//  StatView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/23/25.
//

import Foundation
import SwiftUI

struct StatView: View {
    let value: String
    let label: String
    let icon: Icon

    var body: some View {
        VStack(spacing: 8) {
            IconView(icon: icon)
                .font(.title2)
                .foregroundStyle(.tint)

            Text(value)
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}
