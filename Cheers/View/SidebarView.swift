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

                    NavigationLink(value: NavigationDestination.brands) {
                        Label("Brands", systemImage: "storefront.fill")
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
        .floatingAction(
            title: "Add",
            systemImage: "plus",
            menuItems: floatingMenuItems,
            position: .bottomCenter
        )
        .cabinetModSheet(activeSheet: $isCabinetModPresented)
        .shelfModSheet(activeSheet: $isShelfModPresented)
        .drinkModSheet(activeSheet: $isDrinkModPresented)
    }

    private var floatingMenuItems: [FloatingMenuItem] {
        var menuItems: [FloatingMenuItem] = [
            addCabinetMenuItem,
            addShelfMenuItem,
        ]

        if !shelvesForCount.isEmpty {
            menuItems.append(addDrinkMenuItem)
        }

        return menuItems;
    }

    private var addCabinetMenuItem: FloatingMenuItem {
        .init(title: "Add Cabinet", systemImageName: "plus") {
            isCabinetModPresented = .add
        }
    }

    private var addShelfMenuItem: FloatingMenuItem {
        .init(title: "Add Shelf", systemImageName: "plus") {
            isShelfModPresented = .add()
        }
    }

    private var addDrinkMenuItem: FloatingMenuItem {
        .init(title: "Add Drink", systemImageName: "plus") {
            isDrinkModPresented = .add(DrinkModView.Config())
        }
    }
}
