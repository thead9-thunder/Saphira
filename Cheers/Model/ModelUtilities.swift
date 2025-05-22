//
//  ModelUtilities.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData

struct ModelUtilities {
    static var schema: Schema {
        Schema([
            Drink.self,
            Brand.self,
            Tasting.self
        ])
    }

    static var persistentModelContainer: ModelContainer = modelContainer(isStoredInMemoryOnly: false)

    static var inMemoryModelContainer: ModelContainer = modelContainer(isStoredInMemoryOnly: true)

    private static func modelContainer(isStoredInMemoryOnly: Bool) -> ModelContainer {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
