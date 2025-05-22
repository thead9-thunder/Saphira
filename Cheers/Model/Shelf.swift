//
//  Shelf.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData

@Model
class Shelf {
    var id: UUID
    var name: String

    @Relationship(inverse: \Cabinet.shelves)
    var cabinet: Cabinet?

    @Relationship(deleteRule: .cascade)
    var drinks: [Drink]? = []

    init(name: String, cabinet: Cabinet?) {
        self.id = UUID()
        self.name = name
        self.cabinet = cabinet
    }
}

extension Shelf {
    @discardableResult
    static func create(named name: String, in cabinet: Cabinet) -> Shelf {
        let shelf = Shelf(name: name, cabinet: cabinet)
        cabinet.modelContext?.insert(shelf)
        cabinet.shelves?.append(shelf)

        return shelf
    }

    @discardableResult
    static func create(named name: String, for context: ModelContext) -> Shelf {
        let shelf = Shelf(name: name, cabinet: nil)
        context.insert(shelf)

        return shelf
    }
}

extension Shelf {
    static var alphabetical: FetchDescriptor<Shelf> {
        FetchDescriptor<Shelf>(
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }

    static var notInCabinet: FetchDescriptor<Shelf> {
        FetchDescriptor<Shelf>(
            predicate: #Predicate { $0.cabinet == nil },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }

    static func inCabinet(_ cabinet: Cabinet) -> FetchDescriptor<Shelf> {
        let cabinetID = cabinet.id
        return FetchDescriptor<Shelf>(
            predicate: #Predicate { $0.cabinet?.id == cabinetID},
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }
}
