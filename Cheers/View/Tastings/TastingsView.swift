//
//  TastingsView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI
import SwiftData

struct TastingsView: View {
    @Query var tastings: [Tasting]

    init(tastings: FetchDescriptor<Tasting>) {
        _tastings = Query(tastings)
    }

    var body: some View {
        VStack {
            Text("# of tastings: \(tastings.count)")
            List {
                ForEach(tastings) { tasting in
                    Text("Drank at \(tasting.date)")
                }
            }
        }
    }
}
