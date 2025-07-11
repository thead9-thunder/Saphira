//
//  Icons.swift
//  Cheers
//
//  Created by Thomas Headley on 6/28/25.
//

import Foundation

struct IconCategory: Identifiable {
    let name: String
    var id: String {
        name
    }
    let icons: [Icon]
}

extension IconCategory {
    static let all = [coffeeAndTea, fitness, alcohol, miscellaneous, organization]
    
    static let coffeeAndTea = IconCategory(
        name: "Coffee & Tea",
        icons: [
            .sfSymbol("cup.and.saucer"), .sfSymbol("cup.and.saucer.fill"),
            .sfSymbol("cup.and.heat.waves"), .sfSymbol("cup.and.heat.waves.fill"),
            .sfSymbol("mug"), .sfSymbol("mug.fill"),
            .customSFSymbol("tea"), .customSFSymbol("tea.fill"),
            .customSFSymbol("moka.pot"), .customSFSymbol("moka.pot.fill"),
            .customSFSymbol("coffee.togo"), .customSFSymbol("coffee.togo.fill"),
        ]
    )
    
    static let fitness = IconCategory(
        name: "Water & Fitness",
        icons: [
            .sfSymbol("drop"), .sfSymbol("drop.fill"),
            .sfSymbol("waterbottle"), .sfSymbol("waterbottle.fill"),
            .customSFSymbol("bottle.water"), .customSFSymbol("bottle.water.fill"),
            .customSFSymbol("sport.bottle"), .customSFSymbol("sport.bottle.fill"),
            .customSFSymbol("energy.drink"), .customSFSymbol("energy.drink.fill"),
            .sfSymbol("bubbles.and.sparkles"), .sfSymbol("bubbles.and.sparkles.fill"),
            .customSFSymbol("barbell"),
        ]
    )
    
    static let alcohol = IconCategory(
        name: "Alcohol",
        icons: [
            .sfSymbol("wineglass"), .sfSymbol("wineglass.fill"),
            .customSFSymbol("cocktail"), .customSFSymbol("cocktail.fill"),
            .customSFSymbol("coconut.cocktail"), .customSFSymbol("coconut.cocktail.fill"),
            .customSFSymbol("wine.bottle"), .customSFSymbol("wine.bottle.fill"),
            .customSFSymbol("vodka.bottle"), .customSFSymbol("vodka.bottle.fill"),
            .customSFSymbol("champagne.bottle"), .customSFSymbol("champagne.bottle.fill"),
            .customSFSymbol("toast"), .customSFSymbol("toast.fill"),
            .customSFSymbol("shot"), .customSFSymbol("shot.fill"),
            .customSFSymbol("beer.mug"), .customSFSymbol("beer.mug.fill"),
            .customSFSymbol("beer.glass"), .customSFSymbol("beer.glass.fill"),
            .customSFSymbol("guinness.beer"), .customSFSymbol("guinness.beer.fill"),
            .customSFSymbol("wooden.keg"), .customSFSymbol("wooden.keg.fill"),
        ]
    )
    
    static let miscellaneous = IconCategory(
        name: "Miscellaneous",
        icons: [
            .sfSymbol("takeoutbag.and.cup.and.straw"), .sfSymbol("takeoutbag.and.cup.and.straw.fill"),
            .customSFSymbol("soda"), .customSFSymbol("soda.fill"),
            .customSFSymbol("cola"), .customSFSymbol("cola.fill"),
            .customSFSymbol("milkshake"), .customSFSymbol("milkshake.fill"),
            .customSFSymbol("bottle.cap"), .customSFSymbol("bottle.cap.fill"),
            .customSFSymbol("milk.bottle"), .customSFSymbol("milk.bottle.fill"),
            .customSFSymbol("tetra.pak"), .customSFSymbol("tetra.pak.fill"),
        ]
    )
        
    static let organization = IconCategory(
        name: "Organization",
        icons: [
            .sfSymbol("cabinet"), .sfSymbol("cabinet.fill"),
            .sfSymbol("case"), .sfSymbol("case.fill"),
            .sfSymbol("bookmark"), .sfSymbol("bookmark.fill"),
            .sfSymbol("tag"), .sfSymbol("tag.fill"),
            .sfSymbol("book"), .sfSymbol("book.fill"),
            .sfSymbol("tray"), .sfSymbol("tray.fill"),
            .sfSymbol("tray.full"), .sfSymbol("tray.full.fill"),
            .sfSymbol("tray.2"), .sfSymbol("tray.2.fill"),
            .sfSymbol("folder"), .sfSymbol("folder.fill"),
            .sfSymbol("list.clipboard"), .sfSymbol("list.clipboard.fill"),
            .sfSymbol("list.bullet.clipboard"), .sfSymbol("list.bullet.clipboard.fill"),
            .sfSymbol("archivebox"), .sfSymbol("archivebox.fill"),
            .sfSymbol("trash"), .sfSymbol("trash.fill"),
            .sfSymbol("list.bullet"),
            .sfSymbol("list.dash"),
            .sfSymbol("list.triangle"),
            .sfSymbol("list.number"),
            .sfSymbol("list.star"),
        ]
    )
}
