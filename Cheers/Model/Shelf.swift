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
    var createdAt: Date
    var name: String
    var isPinned: Bool = false

    @Relationship(inverse: \Cabinet.shelves)
    var cabinet: Cabinet?

    @Relationship(deleteRule: .cascade)
    var drinks: [Drink]? = []

    init(name: String, cabinet: Cabinet?) {
        self.id = UUID()
        self.createdAt = Date.now
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

// MARK: Predicates
extension Shelf {
    static func searchPredicate(searchText: String) -> Predicate<Shelf> {
        #Predicate { shelf in
            searchText.isEmpty || shelf.name.localizedStandardContains(searchText)
        }
    }
    
    static func pinnedPredicate() -> Predicate<Shelf> {
        #Predicate { $0.isPinned }
    }
    
    static func notInCabinetPredicate() -> Predicate<Shelf> {
        #Predicate { $0.cabinet == nil }
    }
    
    static func inCabinetPredicate(cabinetID: UUID) -> Predicate<Shelf> {
        #Predicate { $0.cabinet?.id == cabinetID }
    }
}

// MARK: Sort Descriptors
extension Shelf {
    static func nameSortDescriptor(order: SortOrder = .forward) -> [SortDescriptor<Shelf>] {
        [SortDescriptor(\.name, order: order)]
    }
}

// MARK: Fetch Descriptors
extension Shelf {
    static func search(searchText: String) -> FetchDescriptor<Shelf> {
        FetchDescriptor<Shelf>(
            predicate: searchPredicate(searchText: searchText),
            sortBy: nameSortDescriptor()
        )
    }
    
    static var alphabetical: FetchDescriptor<Shelf> {
        FetchDescriptor<Shelf>(
            sortBy: nameSortDescriptor()
        )
    }

    static var pinned: FetchDescriptor<Shelf> {
        FetchDescriptor<Shelf>(
            predicate: pinnedPredicate(),
            sortBy: nameSortDescriptor()
        )
    }

    static var forCount: FetchDescriptor<Shelf> {
        var descriptor = FetchDescriptor<Shelf>()
        descriptor.propertiesToFetch = []

        return descriptor
    }

    static var notInCabinet: FetchDescriptor<Shelf> {
        FetchDescriptor<Shelf>(
            predicate: notInCabinetPredicate(),
            sortBy: nameSortDescriptor()
        )
    }

    static func inCabinet(_ cabinet: Cabinet) -> FetchDescriptor<Shelf> {
        let cabinetID = cabinet.id
        return FetchDescriptor<Shelf>(
            predicate: inCabinetPredicate(cabinetID: cabinetID),
            sortBy: nameSortDescriptor()
        )
    }
}
