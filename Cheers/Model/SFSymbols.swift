//
//  SFSymbols.swift
//  Cheers
//
//  Created by Thomas Headley on 6/28/25.
//

import Foundation

struct SFSymbolCategory: Identifiable {
    let name: String
    var id: String {
        name
    }
    let sfSymbols: [String]
}

extension SFSymbolCategory {
    static let all = [wine, coffee]
    
    static let wine = SFSymbolCategory(
        name: "Wine",
        sfSymbols: [
            "wineglass", "wineglass.fill"
        ]
    )
    
    static let coffee = SFSymbolCategory(
        name: "Coffee",
        sfSymbols: [
            "cup.and.saucer", "cup.and.saucer.fill"
        ]
    )
}
