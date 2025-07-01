//
//  ToastHelpers.swift
//  Cheers
//
//  Created by Thomas Headley on 6/8/25.
//

import Foundation
import SwiftUI

extension ToastManager {
    func showDrinkLoggedToast(for drink: Drink) {
        let title = "Added to Logbook"
        let message = drink.brand != nil ? "\(drink.name) (\(drink.brand!.name))" : drink.name
        
        showToast(Toast(
            title: title,
            message: message,
            icon: drink.icon,
            type: .success(backgroundColor: .accentColor, foregroundColor: .white)
        ))
    }
    
    func showDrinkCreatedToast(for drink: Drink) {
        let title = "Drink Created"
        let message = drink.brand != nil ? "\(drink.name) (\(drink.brand!.name))" : drink.name
        
        showToast(Toast(
            title: title,
            message: message,
            icon: drink.icon,
            type: .success(backgroundColor: .accentColor, foregroundColor: .white)
        ))
    }
    
    func showDrinkDeletedToast(for drinkName: String) {
        showToast(Toast(
            title: "Drink Deleted",
            message: drinkName,
            icon: .sfSymbol("trash.fill"),
            type: .success(backgroundColor: .red, foregroundColor: .white)
        ))
    }
} 
