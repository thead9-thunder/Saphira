//
//  Tasting.swift
//  Cheers
//
//  Created by Thomas Headley on 5/17/25.
//

import Foundation
import SwiftData

@Model
class Tasting {
    var id: UUID
    var createdAt: Date
    var date: Date
    var notes: String?

    @Relationship(inverse: \Drink.tastings)
    var drink: Drink?

    init(date: Date) {
        self.id = UUID()
        self.createdAt = Date.now
        self.date = date
    }
}

extension Tasting {
    @discardableResult
    static func create(for drink: Drink, at date: Date = .now) -> Tasting {
        let tasting = Tasting(date: date)
        drink.modelContext?.insert(tasting)
        drink.tastings?.append(tasting)

        return tasting
    }
}

extension Tasting {
    static func latest(limit: Int? = nil) -> FetchDescriptor<Tasting> {
        var descriptor = FetchDescriptor<Tasting>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        if let limit {
            descriptor.fetchLimit = limit
        }
        return descriptor
    }

    static func forDrink(_ drink: Drink) -> FetchDescriptor<Tasting> {
        let drinkID = drink.id
        return FetchDescriptor<Tasting>(
            predicate: #Predicate { $0.drink?.id == drinkID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
    }

    static func forShelf(_ shelf: Shelf, limit: Int? = nil) -> FetchDescriptor<Tasting> {
        let drinkIDs = shelf.drinks?.map { $0.id } ?? []
        var descriptor = FetchDescriptor<Tasting>(
            predicate: #Predicate<Tasting> { tasting in
                tasting.drink.flatMap { drink in drinkIDs.contains(drink.id) } ?? false
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        if let limit {
            descriptor.fetchLimit = limit
        }
        return descriptor
    }

    static func forBrand(_ brand: Brand, limit: Int? = nil) -> FetchDescriptor<Tasting> {
        let drinkIDs = brand.drinks?.map { $0.id } ?? []
        var descriptor = FetchDescriptor<Tasting>(
            predicate: #Predicate<Tasting> { tasting in
                tasting.drink.flatMap { drink in drinkIDs.contains(drink.id) } ?? false
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        if let limit {
            descriptor.fetchLimit = limit
        }
        return descriptor
    }

    static func forFavorites(limit: Int? = nil) -> FetchDescriptor<Tasting> {
        var descriptor = FetchDescriptor<Tasting>(
            predicate: #Predicate<Tasting> { tasting in
                tasting.drink?.isFavorite ?? false
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        if let limit {
            descriptor.fetchLimit = limit
        }
        return descriptor
    }

    static func forInStock(limit: Int? = nil) -> FetchDescriptor<Tasting> {
        var descriptor = FetchDescriptor<Tasting>(
            predicate: #Predicate<Tasting> { tasting in
                tasting.drink?.isInStock ?? false
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        if let limit {
            descriptor.fetchLimit = limit
        }
        return descriptor
    }
}
