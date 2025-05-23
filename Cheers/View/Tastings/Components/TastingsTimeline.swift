//
//  TastingsTimeline.swift
//  Cheers
//
//  Created by Thomas Headley on 5/22/25.
//

import Foundation
import SwiftUI
import SwiftData

struct TastingsTimeline: View {
    @Query var tastings: [Tasting]

    init(tastings: FetchDescriptor<Tasting>) {
        _tastings = Query(tastings)
    }

    init(tastings: Query<Tasting, Array<Tasting>>) {
        _tastings = tastings
    }

    var body: some View {
        ForEach(tastings) { tasting in
            TastingCell(tasting: tasting)
        }
    }
}
