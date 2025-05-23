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
    var date: Date
    var notes: String?

    @Relationship(inverse: \Drink.tastings)
    var drink: Drink?

    init(date: Date) {
        self.id = UUID()
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
    static func forDrink(_ drink: Drink) -> FetchDescriptor<Tasting> {
        let drinkID = drink.id
        return FetchDescriptor<Tasting>(
            predicate: #Predicate { $0.drink?.id == drinkID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
    }
}
