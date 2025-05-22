//
//  PersistentModelExtensions.swift
//  Cheers
//
//  Created by Thomas Headley on 5/18/25.
//

import Foundation
import SwiftData

extension PersistentModel {
    func delete() {
        modelContext?.delete(self)
    }
}
