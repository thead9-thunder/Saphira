//
//  BrandsView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import SwiftUI
import SwiftData

struct BrandsView: View {
    @Query(Brand.alphabetical) var brands: [Brand]

    @State private var activeSheet: BrandModView.Mode?

    var body: some View {
        List {
            ForEach(brands) { brand in
                NavigationLink(value: NavigationDestination.brand(brand)) {
                    BrandCellView(brand: brand)
                }
            }
        }
        .navigationTitle("Brands")
        .floatingAction(systemImage: "plus", position: .bottomCenter) {
            activeSheet = .add
        }
        .brandModSheet(activeSheet: $activeSheet)
    }
}

#Preview {
    BrandsView()
}
