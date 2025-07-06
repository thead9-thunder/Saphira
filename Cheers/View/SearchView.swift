//
//  SearchView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/16/25.
//

import Foundation
import SwiftUI
import SwiftData

struct SearchView: View {
    let searchText: String
    let mode: Mode
    
    @Query private var drinks: [Drink]
    @Query private var shelves: [Shelf]
    @Query private var brands: [Brand]
    
    @State private var isDrinkModPresented: DrinkModView.Mode?
    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isBrandModPresented: BrandModView.Mode?
        
    init(searchText: String, mode: Mode) {
        self.searchText = searchText
        self.mode = mode
        
        switch mode {
        case .all:
            self._drinks = Query(Drink.search(searchText: searchText))
            self._shelves = Query(Shelf.search(searchText: searchText))
            self._brands = Query(Brand.search(searchText: searchText))
            
        case .shelf(let shelf):
            self._drinks = Query(Drink.searchOnShelf(searchText: searchText, shelf: shelf))
            self._shelves = Query(filter: #Predicate { _ in false })
            self._brands = Query(filter: #Predicate { _ in false })
            
        case .brands:
            self._drinks = Query(filter: #Predicate { _ in false })
            self._shelves = Query(filter: #Predicate { _ in false })
            self._brands = Query(Brand.search(searchText: searchText))
            
        case .brand(let brand):
            self._drinks = Query(Drink.searchByBrand(searchText: searchText, brand: brand))
            self._shelves = Query(filter: #Predicate { _ in false })
            self._brands = Query(filter: #Predicate { _ in false })
            
        case .drinks(let drinksDescriptor):
            self._drinks = Query(Drink.searchInQuery(searchText: searchText, descriptor: drinksDescriptor))
            self._shelves = Query(filter: #Predicate { _ in false })
            self._brands = Query(filter: #Predicate { _ in false })
        }
    }

    var body: some View {
        List(selection: selectionBinding) {
            if shouldShowEmptyState {
                emptyStateView
            } else if shouldShowNoResultsState {
                noResultsView
            } else {
                contentSections
            }
            
            if !searchText.isEmpty {
                addNewSection
            }
        }
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var selectionBinding: Binding<NavigationDestination?>? {
        switch mode {
        case .all(let binding):
            return binding
        case .shelf:
            return nil
        case .brands:
            return nil
        case .brand:
            return nil
        case .drinks:
            return nil
        }
    }
    
    private var shouldShowEmptyState: Bool {
        searchText.isEmpty
    }
    
    private var shouldShowNoResultsState: Bool {
        !searchText.isEmpty && hasNoResults
    }
    
    private var hasNoResults: Bool {
        switch mode {
        case .all:
            return shelves.isEmpty && drinks.isEmpty && brands.isEmpty
        case .shelf:
            return drinks.isEmpty
        case .brands:
            return brands.isEmpty
        case .brand:
            return drinks.isEmpty
        case .drinks:
            return drinks.isEmpty
        }
    }
    
    // MARK: - Content Views
    private var emptyStateView: some View {
        ContentUnavailableView(
            emptyStateTitle,
            systemImage: "magnifyingglass",
            description: Text(emptyStateDescription)
        )
    }
    
    private var noResultsView: some View {
        ContentUnavailableView(
            "No Results",
            systemImage: "magnifyingglass",
            description: Text(noResultsDescription)
        )
    }
    
    private var contentSections: some View {
        Group {
            if !shelves.isEmpty {
                sectionView(title: "Shelves", items: shelves) { shelf in
                    ShelfCellView(shelf: shelf)
                } destination: { shelf in
                    NavigationDestination.shelf(shelf)
                }
            }
            
            if !drinks.isEmpty {
                sectionView(title: "Drinks", items: drinks) { drink in
                    DrinkCellView(drink: drink)
                } destination: { drink in
                    NavigationDestination.drink(drink)
                }
            }
            
            if !brands.isEmpty {
                sectionView(title: "Brands", items: brands) { brand in
                    BrandCellView(brand: brand)
                } destination: { brand in
                    NavigationDestination.brand(brand)
                }
            }
        }
    }
        
    private func sectionView<T: Identifiable>(
        title: String,
        items: [T],
        @ViewBuilder content: @escaping (T) -> some View,
        destination: @escaping (T) -> NavigationDestination
    ) -> some View {
        Section(title) {
            ForEach(items) { item in
                NavigationLink(value: destination(item)) {
                    content(item)
                }
            }
        }
    }
    
    private var addNewSection: some View {
        Section {
            switch mode {
            case .all:
                addNewDrinkButton(config: .init(name: searchText))
                addNewShelfButton
                addNewBrandButton
            case .shelf(let shelf):
                addNewDrinkButton(config: .init(name: searchText, shelf: shelf))
            case .brands:
                addNewBrandButton
            case .brand(let brand):
                addNewDrinkButton(config: .init(name: searchText, brand: brand))
            case .drinks:
                addNewDrinkButton(config: .init(name: searchText))
            }
        } header: {
            Text("Add New")
        }
    }
    
    private func addNewDrinkButton(config: DrinkModView.Config) -> some View {
        Button {
            isDrinkModPresented = .add(config)
        } label: {
            Label("Add Drink - \"\(searchText)\"", systemImage: "plus")
        }
        .drinkModSheet(activeSheet: $isDrinkModPresented)
    }
    
    private var addNewShelfButton: some View {
        Button {
            isShelfModPresented = .add()
        } label: {
            Label("Add Shelf - \"\(searchText)\"", systemImage: "plus")
        }
        .shelfModSheet(activeSheet: $isShelfModPresented)
    }
    
    private var addNewBrandButton: some View {
        Button {
            isBrandModPresented = .add
        } label: {
            Label("Add Brand - \"\(searchText)\"", systemImage: "plus")
        }
        .brandModSheet(activeSheet: $isBrandModPresented)
    }
    
    // MARK: - Text Content
    private var emptyStateTitle: String {
        switch mode {
        case .all:
            return "Search"
        case .shelf(let shelf):
            return "Search \(shelf.name)"
        case .brands:
            return "Search Brands"
        case .brand(let brand):
            return "Search \(brand.name)"
        case .drinks:
            return "Search Drinks"
        }
    }
    
    private var emptyStateDescription: String {
        switch mode {
        case .all:
            return "Enter a search term to find shelves, drinks, or brands"
        case .shelf:
            return "Enter a search term to find drinks on this shelf"
        case .brands:
            return "Enter a search term to find brands"
        case .brand(let brand):
            return "Enter a search term to find drinks by \(brand.name)"
        case .drinks:
            return "Enter a search term to find drinks"
        }
    }
    
    private var noResultsDescription: String {
        switch mode {
        case .all:
            return "No shelves, drinks, or brands found matching \"\(searchText)\""
        case .shelf(let shelf):
            return "No drinks found on \(shelf.name) matching \"\(searchText)\""
        case .brands:
            return "No brands found matching \"\(searchText)\""
        case .brand(let brand):
            return "No drinks found by \(brand.name) matching \"\(searchText)\""
        case .drinks:
            return "No drinks found matching \"\(searchText)\""
        }
    }
}

extension SearchView {
    enum Mode {
        case all(Binding<NavigationDestination?>)
        case shelf(Shelf)
        case brands
        case brand(Brand)
        case drinks(FetchDescriptor<Drink>)
    }
}
