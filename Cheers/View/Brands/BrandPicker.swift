//
//  BrandPicker.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData
import SwiftUI

struct BrandPicker: View {
    @Query(Brand.alphabetical) var brands: [Brand]
    @Binding var selectedBrand: Brand?
    @State private var activeSheet: BrandModView.Mode?

    var body: some View {
        HStack {
            Text("Brand")

            Spacer()

            Menu {
                // None
                Button("None") {
                    selectedBrand = nil
                }

                // Existing brands
                ForEach(brands, id: \.self) { brand in
                    Button {
                        selectedBrand = brand
                    } label: {
                        if selectedBrand == brand {
                            Label(brand.name, systemImage: "checkmark")
                        } else {
                            Text(brand.name)
                        }
                    }
                }

                // Create new brand
                Button {
                    activeSheet = .add
                } label: {
                    Label("Create New Brand", systemImage: "plus")
                }
            } label: {
                Text(selectedBrand?.name ?? "Select a brand")
            }
        }
        .brandModSheet(activeSheet: $activeSheet) { committedBrand in
            selectedBrand = committedBrand
        }
    }
}
