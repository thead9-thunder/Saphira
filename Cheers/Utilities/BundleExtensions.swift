//
//  BundleExtensions.swift
//  Cheers
//
//  Created by Thomas Headley on 7/3/25.
//

import Foundation

extension Bundle {
    static var releaseVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    static var buildVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
