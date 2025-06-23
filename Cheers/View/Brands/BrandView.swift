//
//  BrandView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftUI
import SwiftData

struct BrandView: View {
    var brand: Brand

    @State private var isBrandModPresented: BrandModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?
    @State private var searchText = ""
    @State private var isSearchPresented = false

    var body: some View {
        VStack {
            if isSearchPresented {
                SearchView(searchText: searchText, mode: .brand(brand))
            } else {
                DrinksView(config: drinksViewConfig)
            }
        }
        .navigationTitle(brand.name)
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        .toolbar { toolbar }
        .brandModSheet(activeSheet: $isBrandModPresented)
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isBrandModPresented = .edit(brand)
            } label: {
                Label("Info", systemImage: "info")
            }
        }
        
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        ToolbarSpacer(placement: .bottomBar)
        ToolbarItem(placement: .bottomBar) {
            Button {
                isDrinkModPresented = .add(DrinkModView.Config(brand: brand))
            } label: {
                Label("Add Drink", systemImage: "plus")
            }
        }
    }
}

extension BrandView {
    var drinksViewConfig: DrinksView.Config {
        .init(
            drinks: Query(Drink.by(brand: brand)),
            latestTastings: Query(Tasting.forBrand(brand, limit: 10))
        )
    }
}
