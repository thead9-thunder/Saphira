//
//  InfoView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct InfoView: View {
    @Query var drinks: [Drink]
    @Query var brands: [Brand]
    @Query var tastings: [Tasting]

    var body: some View {
        VStack {
            Text("# of drinks \(drinks.count)")
            Text("# of brands \(brands.count)")
            Text("# of tastings \(tastings.count)")
        }
    }
}

#Preview {
    InfoView()
}
