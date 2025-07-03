//
//  ErrorUtilities.swift
//  Cheers
//
//  Created by Thomas Headley on 7/3/25.
//

import Foundation
import StoreKit

struct ErrorUtilities {
    static func userFriendlyMessage(for error: Error) -> String {
        if let storeError = error as? StoreKitError {
            switch storeError {
            case .networkError:
                return "Please check your internet connection and try again."
            case .userCancelled:
                return "Purchase restore was cancelled."
            default:
                return "Unable to restore purchases. Please try again later."
            }
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "Please check your internet connection and try again."
            default:
                return "Network error occurred. Please try again later."
            }
        }
        
        return "Something went wrong. Please try again."
    }
}
