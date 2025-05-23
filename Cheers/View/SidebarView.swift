//
//  SidebarView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI
import SwiftData

struct SidebarView: View {
    @Environment(\.navigationState) private var navigationState
    private var selectedShelfBinding: Binding<Shelf?> {
        Binding<Shelf?>(
            get: { navigationState.selectedShelf },
            set: { navigationState.selectedShelf = $0 }
        )
    }

    @Query private var cabinetsForCount: [Cabinet]
    @Query private var shelvesForCount: [Shelf]
    @Query private var latestTastings: [Tasting]

    @State private var isCabinetModPresented: CabinetModView.Mode?
    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?

    init() {
        _latestTastings = Query(Tasting.latest(limit: 10))
    }

    var body: some View {
        VStack {
            List(selection: selectedShelfBinding) {
                Section {
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Text("Favorites")
                    }

                    NavigationLink {
                        InStockView()
                    } label: {
                        Text("In Stock")
                    }
                }

                if !latestTastings.isEmpty {
                    Section("Latest Tastings") {
                        TastingsReLogCard(tastings: _latestTastings)
                    }
                }

                if shelvesForCount.count == 0 && cabinetsForCount.count == 0 {
                    ContentUnavailableView(
                        "Welcome to Cheers!",
                        systemImage: "cabinet.fill",
                        description: Text("Start your journey by pressing the button below")
                    )
                } else {
                    ShelvesView(shelves: Shelf.notInCabinet)
                    CabinetsView()
                }
            }
        }
        .floatingMenu(
            systemImageName: "plus",
            menuItems: [
                addCabinetMenuItem,
                addShelfMenuItem,
            ],
            position: .bottomCenter
        )
        .cabinetModSheet(activeSheet: $isCabinetModPresented)
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
    }

    private var addCabinetMenuItem: FloatingMenuModifier.MenuItem {
        .init(title: "Add Cabinet", systemImageName: "plus") {
            isCabinetModPresented = .add
        }
    }

    private var addShelfMenuItem: FloatingMenuModifier.MenuItem {
        .init(title: "Add Shelf", systemImageName: "plus") {
            isShelfModPresented = .add()
        }
    }

    private var addDrinkMenuItem: FloatingMenuModifier.MenuItem {
        .init(title: "Add Drink", systemImageName: "plus") {
            isDrinkModPresented = .add(DrinkModView.Config())
        }
    }
}
