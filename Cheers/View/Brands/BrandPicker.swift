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
    @Environment(\.dismiss) private var dismiss

    @Query(Brand.alphabetical) var brands: [Brand]

    @Binding var selectedBrand: Brand?

    @State private var activeSheet: BrandModView.Mode?

    var body: some View {
        Group {
            if brands.isEmpty {
                ContentUnavailableView {
                    Label("No Brands", systemImage: "storefront.fill")
                } description: {
                    Text("Add your first brand to get started")
                } actions: {
                    Button {
                        activeSheet = .add
                    } label: {
                        Label("Add Brand", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    // None option
                    Button {
                        select(nil)
                    } label: {
                        Label {
                            HStack {
                                Text("None")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        } icon: {
                            Image(systemName: selectedBrand == nil ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .buttonStyle(.plain)

                    // Existing brands
                    ForEach(brands, id: \.self) { brand in
                        Button {
                            select(brand)
                        } label: {
                            Label {
                                HStack {
                                    Text(brand.name)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            } icon: {
                                Image(systemName: selectedBrand == brand ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Select Brand")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    activeSheet = .add
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .brandModSheet(activeSheet: $activeSheet) { committedBrand in
            select(committedBrand)
        }
    }

    func select(_ brand: Brand?) {
        selectedBrand = brand
        dismiss()
    }
}

// MARK: - BrandPickerButton
struct BrandPickerButton: View {
    @Binding var selectedBrand: Brand?
    
    var body: some View {
        NavigationLink {
            BrandPicker(selectedBrand: $selectedBrand)
        } label: {
            HStack {
                Text("Brand")
                    .foregroundStyle(.primary)
                Spacer()

                Text(selectedBrand?.name ?? "Select a brand")
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}
