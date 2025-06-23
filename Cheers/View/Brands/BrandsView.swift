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
    @State private var searchText = ""
    @State private var isSearchPresented = false

    var body: some View {
        VStack {
            if isSearchPresented {
                SearchView(searchText: searchText, mode: .brands)
            } else {
                List {
                    ForEach(brands) { brand in
                        NavigationLink(value: NavigationDestination.brand(brand)) {
                            BrandCellView(brand: brand)
                        }
                    }
                }
            }
        }
        .navigationTitle("Brands")
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        .toolbar { toolbar }
        .brandModSheet(activeSheet: $activeSheet)
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        ToolbarSpacer(placement: .bottomBar)
        ToolbarItem(placement: .bottomBar) {
            Button {
                activeSheet = .add
            } label: {
                Label("Add Brand", systemImage: "plus")
            }
        }
    }
}
