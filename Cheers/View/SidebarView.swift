//
//  SidebarView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/1/25.
//

import Foundation
import SwiftUI
import SwiftData

struct SidebarView: View {
    @Binding var selectedItem: NavigationDestination?

    @Query private var cabinetsForCount: [Cabinet]
    @Query private var pinnedShelves: [Shelf]
    @Query private var shelvesForCount: [Shelf]
    @Query private var latestTastings: [Tasting]

    @State private var isSettingsViewPresented: Bool = false
    @State private var isCabinetModPresented: CabinetModView.Mode?
    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?
    @State private var searchText = ""
    @State private var isSearchPresented = false

    init(selectedItem: Binding<NavigationDestination?>) {
        self._selectedItem = selectedItem
        self._pinnedShelves = Query(Shelf.pinned)
        self._cabinetsForCount = Query(Cabinet.forCount)
        self._shelvesForCount = Query(Shelf.forCount)
        self._latestTastings = Query(Tasting.latest(limit: 10))
    }

    var body: some View {
        VStack {
            if isSearchPresented {
                SearchView(searchText: searchText)
            } else {
                List(selection: $selectedItem) {
                    specialShelvesSection
                    
                    if !latestTastings.isEmpty {
                        latestTastingsSection
                    }
                    
                    if shelvesForCount.isEmpty && cabinetsForCount.isEmpty {
                        ContentUnavailableView(
                            "Welcome to Cheers!",
                            systemImage: "cabinet.fill",
                            description: Text("Start your journey by pressing the button below")
                        )
                    } else {
                        cabinetsAndShelvesSection
                    }
                }
            }
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
        .toolbar { toolbar }
        .sheet(isPresented: $isSettingsViewPresented) {
            NavigationStack {
                SettingsView()
            }
        }
        .cabinetModSheet(activeSheet: $isCabinetModPresented)
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        if !isSearchPresented {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isSettingsViewPresented = true
                } label: {
                    Label("Settings", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSearchPresented = true
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .labelStyle(.iconOnly)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                addMenu
            }
        }
    }

    private var searchView: some View {
        Text("Search")
    }

    private var addMenu: some View {
        Menu {
            Button {
                isCabinetModPresented = .add
            } label: {
                Label("Add Cabinet", systemImage: "plus")
            }

            Button {
                isShelfModPresented = .add()
            } label: {
                Label("Add Shelf", systemImage: "plus")
            }

            if !shelvesForCount.isEmpty {
                Button {
                    isDrinkModPresented = .add(DrinkModView.Config())
                } label: {
                    Label("Add Drink", systemImage: "plus")
                }
            }
        } label: {
            Button {} label: {
                Label("Add", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var specialShelvesSection: some View {
        Section {
            NavigationLink(value: NavigationDestination.favorites) {
                Label {
                    Text("Favorites")
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }

            NavigationLink(value: NavigationDestination.inStock) {
                Label {
                    Text("In Stock")
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }

            NavigationLink(value: NavigationDestination.brands) {
                Label {
                    Text("Brands")
                } icon: {
                    Image(systemName: "storefront.fill")
                        .foregroundStyle(.purple)
                }
            }
        }
    }

    private var latestTastingsSection: some View {
        Section("Latest Tastings") {
            TastingsReLogCard(tastings: _latestTastings)
        }
    }

    @ViewBuilder
    private var cabinetsAndShelvesSection: some View {
        if !pinnedShelves.isEmpty {
            Section {
                ShelvesView(shelves: _pinnedShelves)
            } header: {
                Label("Pinned", systemImage: "pin")
            }
        }

        Section {
            ShelvesView(shelves: Shelf.notInCabinet)
        } header: {
            Text("No Cabinet")
        }

        CabinetsView(isShelfModPresented: $isShelfModPresented)
    }
}
