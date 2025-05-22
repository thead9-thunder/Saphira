//
//  Cabinet.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData

@Model
class Cabinet {
    var id: UUID
    var name: String

    @Relationship(deleteRule: .cascade)
    var shelves: [Shelf]? = []

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

extension Cabinet {
    @discardableResult
    static func create(named name: String, for context: ModelContext) -> Cabinet {
        let cabinet = Cabinet(name: name)
        context.insert(cabinet)

        return cabinet
    }
}

extension Cabinet {
    static var alphabetical: FetchDescriptor<Cabinet> {
        FetchDescriptor<Cabinet>(
            sortBy: [SortDescriptor(\.name, order: .forward)]
        )
    }
}
