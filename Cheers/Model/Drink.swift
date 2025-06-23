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

    var isPinned: Bool = false

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

// MARK: Predicates
extension Drink {
    static func searchPredicate(searchText: String) -> Predicate<Drink> {
        #Predicate { drink in
            searchText.isEmpty || 
            drink.name.localizedStandardContains(searchText) ||
            drink.brand?.name.localizedStandardContains(searchText) == true
        }
    }
    
    static func favoritesPredicate() -> Predicate<Drink> {
        #Predicate { $0.isFavorite }
    }
    
    static func inStockPredicate() -> Predicate<Drink> {
        #Predicate { $0.isInStock }
    }
    
    static func byBrandPredicate(brandID: UUID) -> Predicate<Drink> {
        #Predicate { $0.brand?.id == brandID }
    }
    
    static func onShelfPredicate(shelfID: UUID) -> Predicate<Drink> {
        #Predicate { $0.shelf?.id == shelfID }
    }
}

// MARK: Sort Descriptors
extension Drink {
    static func nameSortDescriptor(order: SortOrder = .forward) -> [SortDescriptor<Drink>] {
        [SortDescriptor(\.name, order: order)]
    }
}

// MARK: Fetch Descriptors
extension Drink {
    static func search(searchText: String) -> FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            predicate: searchPredicate(searchText: searchText),
            sortBy: nameSortDescriptor()
        )
    }
    
    static func searchOnShelf(searchText: String, shelf: Shelf) -> FetchDescriptor<Drink> {
        let shelfPredicate = onShelfPredicate(shelfID: shelf.id)
        let searchPredicate = searchPredicate(searchText: searchText)
        
        let fullPredicate = #Predicate<Drink> { drink in
            shelfPredicate.evaluate(drink) && searchPredicate.evaluate(drink)
        }
        
        return FetchDescriptor<Drink>(
            predicate: fullPredicate,
            sortBy: nameSortDescriptor()
        )
    }
    
    static func searchByBrand(searchText: String, brand: Brand) -> FetchDescriptor<Drink> {
        let brandPredicate = byBrandPredicate(brandID: brand.id)
        let searchPredicate = searchPredicate(searchText: searchText)
        
        let fullPredicate = #Predicate<Drink> { drink in
            brandPredicate.evaluate(drink) && searchPredicate.evaluate(drink)
        }
        
        return FetchDescriptor<Drink>(
            predicate: fullPredicate,
            sortBy: nameSortDescriptor()
        )
    }
    
    static func searchInQuery(searchText: String, descriptor: FetchDescriptor<Drink>) -> FetchDescriptor<Drink> {
        let searchPredicate = searchPredicate(searchText: searchText)
        
        guard let originalPredicate = descriptor.predicate else {
            return FetchDescriptor<Drink>(
                predicate: searchPredicate,
                sortBy: descriptor.sortBy
            )
        }
        
        let fullPredicate = #Predicate<Drink> { drink in
            originalPredicate.evaluate(drink) && searchPredicate.evaluate(drink)
        }
        
        return FetchDescriptor<Drink>(
            predicate: fullPredicate,
            sortBy: descriptor.sortBy
        )
    }
    
    static var alphabetical: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            sortBy: nameSortDescriptor()
        )
    }

    static var favorites: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            predicate: favoritesPredicate(),
            sortBy: nameSortDescriptor()
        )
    }

    static var inStock: FetchDescriptor<Drink> {
        FetchDescriptor<Drink>(
            predicate: inStockPredicate(),
            sortBy: nameSortDescriptor()
        )
    }

    static func by(brand: Brand) -> FetchDescriptor<Drink> {
        let brandID = brand.id
        return FetchDescriptor<Drink>(
            predicate: byBrandPredicate(brandID: brandID),
            sortBy: nameSortDescriptor()
        )
    }

    static func on(shelf: Shelf) -> FetchDescriptor<Drink> {
        let shelfID = shelf.id
        return FetchDescriptor<Drink>(
            predicate: onShelfPredicate(shelfID: shelfID),
            sortBy: nameSortDescriptor()
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
