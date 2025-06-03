//
//  SidebarView2.swift
//  Cheers
//
//  Created by Thomas Headley on 6/1/25.
//

import Foundation
import SwiftUI
import SwiftData

struct SidebarView2: View {
    @Binding var selectedItem: NavigationDestination?

    @Query private var cabinetsForCount: [Cabinet]
    @Query private var shelvesForCount: [Shelf]
    @Query private var latestTastings: [Tasting]

    @State private var isCabinetModPresented: CabinetModView.Mode?
    @State private var isShelfModPresented: ShelfModView.Mode?
    @State private var isDrinkModPresented: DrinkModView.Mode?

    var body: some View {
        VStack {
            List(selection: $selectedItem) {
                Section {
                    NavigationLink(value: NavigationDestination.favorites) {
                        Label("Favorites", systemImage: "star.fill")
                    }

                    NavigationLink(value: NavigationDestination.inStock) {
                        Label("In Stock", systemImage: "checkmark.circle.fill")
                    }
                }

                if !latestTastings.isEmpty {
                    Section("Latest Tastings") {
                        TastingsReLogCard(tastings: _latestTastings)
                    }
                }

                if shelvesForCount.isEmpty && cabinetsForCount.isEmpty {
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
            menuItems: floatingMenuItems,
            position: .bottomCenter
        )
        .cabinetModSheet(activeSheet: $isCabinetModPresented)
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
    }

    private var floatingMenuItems: [FloatingMenuModifier.MenuItem] {
        var menuItems: [FloatingMenuModifier.MenuItem] = [
            addCabinetMenuItem,
            addShelfMenuItem,
        ]

        if !shelvesForCount.isEmpty {
            menuItems.append(addDrinkMenuItem)
        }

        return menuItems;
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
