//
//  Drink.swift
//  Cheers
//
//  Created by Thomas Headley on 5/17/25.
//

import Foundation
import SwiftData

@Model
class Drink {
    var id: UUID
    var createdAt: Date
    var name: String

    var isFavorite: Bool = false
    var isInStock: Bool = false

    @Relationship(deleteRule: .nullify)
    var brand: Brand?

    @Relationship(inverse: \Shelf.drinks)
    var shelf: Shelf?

    @Relationship(deleteRule: .cascade)
    var tastings: [Tasting]? = []

    private init(name: String) {
        self.id = UUID()
        self.createdAt = Date.now
        self.name = name
    }
}

extension Drink {
    @discardableResult
    static func create(named name: String, for context: ModelContext) -> Drink {
        let drink = Drink(name: name)
        context.insert(drink)

        return drink
    }
}

extension Drink {
    static var alphabetical: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }

    static var favorites: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            predicate: #Predicate { $0.isFavorite },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }

    static var inStock: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            predicate: #Predicate { $0.isInStock },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }

    static func by(brand: Brand) -> FetchDescriptor<Drink> {
        let brandID = brand.id
        return FetchDescriptor<Drink>(
            predicate: #Predicate { $0.brand?.id == brandID },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }

    static func on(shelf: Shelf) -> FetchDescriptor<Drink> {
        let shelfID = shelf.id
        return FetchDescriptor<Drink>(
            predicate: #Predicate { $0.shelf?.id == shelfID },
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }
}

extension Drink {
    static let sampleData = [
        Drink(name: "Orange Juice"),
        Drink(name: "Coke Zero"),
        Drink(name: "Coffee"),
    ]
}
