//
//  CabinetsView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI
import SwiftData

struct CabinetsView: View {
    @Query var cabinets: [Cabinet]

    @State private var isShelfModPresented: ShelfModView.Mode?

    init(cabinets: FetchDescriptor<Cabinet> = Cabinet.alphabetical) {
        _cabinets = Query(cabinets)
    }

    var body: some View {
        ForEach(cabinets) { cabinet in
            Section {
                if cabinet.shelves?.count ?? 0 == 0 {
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                isShelfModPresented = .add(cabinet)
                            } label: {
                                Label {
                                    Text("Add shelf")
                                        .font(.system(size: 16, weight: .semibold))
                                } icon: {
                                    Image(systemName: "plus")
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
                                .shadow(radius: 4)
                            }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .shelfModSheet(activeSheet: $isShelfModPresented)
                    }
                } else {
                    ShelvesView(shelves: Shelf.inCabinet(cabinet))
                }
            } header: {
                CabinetHeaderView(cabinet: cabinet)
            }
        }
    }
}
