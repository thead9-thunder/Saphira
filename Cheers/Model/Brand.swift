//
//  Brand.swift
//  Cheers
//
//  Created by Thomas Headley on 5/17/25.
//

import Foundation
import SwiftData

@Model
class Brand {
    var id: UUID
    var createdAt: Date
    var name: String

    @Relationship(inverse: \Drink.brand)
    var drinks: [Drink]?

    init(name: String) {
        self.id = UUID()
        self.createdAt = Date.now
        self.name = name
    }
}

extension Brand {
    @discardableResult
    static func create(named name: String, for context: ModelContext) -> Brand {
        let brand = Brand(name: name)
        context.insert(brand)

        return brand
    }
}

extension Brand {
    static var alphabetical: FetchDescriptor<Brand> {
        FetchDescriptor<Brand>(
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }
}
