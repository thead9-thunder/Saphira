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
    
    @Query private var shelves: [Shelf]
    @Query private var drinks: [Drink]
    @Query private var brands: [Brand]
        
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
        }
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    
    private var selectionBinding: Binding<NavigationDestination?>? {
        switch mode {
        case .all(let binding):
            return binding
        case .shelf:
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
            switch mode {
            case .all:
                allModeSections
            case .shelf:
                shelfModeSections
            }
        }
    }
    
    private var allModeSections: some View {
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
    
    private var shelfModeSections: some View {
        sectionView(title: "Drinks", items: drinks) { drink in
            DrinkCellView(drink: drink)
        } destination: { drink in
            NavigationDestination.drink(drink)
        }
    }
        
    // MARK: - Helper Views
    
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
    
    // MARK: - Text Content
    private var emptyStateTitle: String {
        switch mode {
        case .all:
            return "Search"
        case .shelf(let shelf):
            return "Search \(shelf.name)"
        }
    }
    
    private var emptyStateDescription: String {
        switch mode {
        case .all:
            return "Enter a search term to find shelves, drinks, or brands"
        case .shelf:
            return "Enter a search term to find drinks on this shelf"
        }
    }
    
    private var noResultsDescription: String {
        switch mode {
        case .all:
            return "No shelves, drinks, or brands found matching \"\(searchText)\""
        case .shelf(let shelf):
            return "No drinks found on \(shelf.name) matching \"\(searchText)\""
        }
    }
}

extension SearchView {
    enum Mode {
        case all(Binding<NavigationDestination?>)
        case shelf(Shelf)
    }
}
