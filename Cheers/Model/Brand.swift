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

// MARK: Predicates
extension Brand {
    static func searchPredicate(searchText: String) -> Predicate<Brand> {
        #Predicate { brand in
            searchText.isEmpty || brand.name.localizedStandardContains(searchText)
        }
    }
}

// MARK: Sort Descriptors
extension Brand {
    static func nameSortDescriptor(order: SortOrder = .forward) -> [SortDescriptor<Brand>] {
        [SortDescriptor(\.name, order: order)]
    }
}

// MARK: Fetch Descriptors
extension Brand {
    static func search(searchText: String) -> FetchDescriptor<Brand> {
        FetchDescriptor<Brand>(
            predicate: searchPredicate(searchText: searchText),
            sortBy: nameSortDescriptor()
        )
    }
    
    static var alphabetical: FetchDescriptor<Brand> {
        FetchDescriptor<Brand>(
            sortBy: nameSortDescriptor()
        )
    }
}
