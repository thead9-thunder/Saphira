//
//  Item.swift
//  Cheers
//
//  Created by Thomas Headley on 5/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
