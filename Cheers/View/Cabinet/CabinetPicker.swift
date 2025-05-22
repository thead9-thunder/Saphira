//
//  CabinetPicker.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData
import SwiftUI

struct CabinetPicker: View {
    @Query(Cabinet.alphabetical) var cabinets: [Cabinet]
    @Binding var selectedCabinet: Cabinet?
    @State private var activeSheet: CabinetModView.Mode?

    var body: some View {
        HStack {
            Text("Cabinet")

            Spacer()

            Menu {
                Button {
                    selectedCabinet = nil
                } label: {
                    Text("None")
                }

                Divider()

                ForEach(cabinets) { cabinet in
                    Button {
                        selectedCabinet = cabinet
                    } label: {
                        if selectedCabinet == cabinet {
                            Label(cabinet.name, systemImage: "checkmark")
                        } else {
                            Text(cabinet.name)
                        }
                    }
                }

                Divider()

                Button {
                    activeSheet = .add
                } label: {
                    Label("Create New Cabinet", systemImage: "plus")
                }
            } label: {
                Text(selectedCabinet?.name ?? "Select a cabinet")
            }
        }
        .cabinetModSheet(activeSheet: $activeSheet) { committedCabinet in
            selectedCabinet = committedCabinet
        }
    }
}
