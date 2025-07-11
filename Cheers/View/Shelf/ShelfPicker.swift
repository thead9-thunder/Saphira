//
//  ShelfPicker.swift
//  Cheers
//
//  Created by Thomas Headley on 5/20/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ShelfPicker: View {
    @Query(Cabinet.alphabetical) var cabinets: [Cabinet]
    @Binding var selectedShelf: Shelf?
    
    @State private var isShelfModPresented: ShelfModView.Mode?

    var body: some View {
        HStack {
            Text("Shelf")

            Spacer()

            Menu {
                Menu {
                    ShelvesInMenu(shelves: Shelf.notInCabinet, selectedShelf: _selectedShelf)
                    
                    Divider()
                    
                    Button {
                        isShelfModPresented = .add(.init())
                    } label: {
                        Label("Add Shelf", systemImage: "plus")
                    }
                } label: {
                    Text("No Cabinet")
                }

                ForEach(cabinets) { cabinet in
                    Menu {
                        ShelvesInMenu(shelves: Shelf.inCabinet(cabinet), selectedShelf: _selectedShelf)
                        
                        Divider()
                        
                        Button {
                            isShelfModPresented = .add(.init(cabinet: cabinet))
                        } label: {
                            Label("Add Shelf", systemImage: "plus")
                        }
                    } label: {
                        Text(cabinet.name)
                    }
                }
            } label: {
                Text(selectedShelf?.name ?? "Select a shelf")
            }
            .shelfModSheet(activeSheet: $isShelfModPresented) { newShelf in
                selectedShelf = newShelf
            }
        }
    }

    struct ShelvesInMenu: View {
        @Query var shelves: [Shelf]
        @Binding var selectedShelf: Shelf?

        init(shelves: FetchDescriptor<Shelf>, selectedShelf: Binding<Shelf?>) {
            _shelves = Query(shelves)
            _selectedShelf = selectedShelf
        }

        var body: some View {
            ForEach(shelves) { shelf in
                Button {
                    selectedShelf = shelf
                } label: {
                    if selectedShelf == shelf {
                        Label(shelf.name, systemImage: "checkmark")
                    } else {
                        Text(shelf.name)
                    }
                }
            }
        }
    }
}
