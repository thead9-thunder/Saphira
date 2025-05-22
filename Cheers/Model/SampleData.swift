//
//  SampleData.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData


@MainActor
class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    private init() {
        modelContainer = ModelUtilities.inMemoryModelContainer
        insertSampleData()
        do {
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private func insertSampleData() {
        for drink in Drink.sampleData {
            context.insert(drink)
        }
    }
}
