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

    @State private var isBrandModPresented: BrandModView.Mode?
    @State private var searchText: String = ""

    var body: some View {
        Group {
            if brands.isEmpty {
                emptyBrandsView
            } else {
                brandsListView
            }
        }
        .navigationTitle("Select Brand")
        .toolbar { toolbar }
        .searchable(text: $searchText)
        .brandModSheet(activeSheet: $isBrandModPresented) { committedBrand in
            select(committedBrand)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isBrandModPresented = .add(.init())
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var filteredBrands: [Brand] {
        if searchText.isEmpty {
            return brands
        } else {
            return brands.filter { brand in
                brand.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var emptyBrandsView: some View {
        ContentUnavailableView {
            Label("No Brands", systemImage: "storefront.fill")
        } description: {
            Text("Add your first brand to get started")
        } actions: {
            Button {
                isBrandModPresented = .add(.init())
            } label: {
                Label("Add Brand", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var brandsListView: some View {
        List {
            if searchText.isEmpty {
                noneOptionView
            }
            
            ForEach(filteredBrands, id: \.self) { brand in
                brandOptionView(for: brand)
            }
            
            if !searchText.isEmpty {
                Button {
                    isBrandModPresented = .add(.init(name: searchText))
                } label: {
                    Label("Add Brand - \"\(searchText)\"", systemImage: "plus")
                }                
            }
        }
    }
    
    private var noneOptionView: some View {
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
    }
    
    private func brandOptionView(for brand: Brand) -> some View {
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
