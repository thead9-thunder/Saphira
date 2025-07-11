//
//  Icon.swift
//  Cheers
//
//  Created by Thomas Headley on 6/25/25.
//

import Foundation
import SwiftData

enum Icon: Codable, Hashable {
    case emoji(String)
    case sfSymbol(String)
    case customSFSymbol(String)
}
