//
//  MailtoURLBuilder.swift
//  Cheers
//
//  Created by Thomas Headley on 7/3/25.
//

import Foundation

class MailtoURLBuilder {
    
    static func buildMailtoURL(email: String, subject: String? = nil, body: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        
        var queryItems: [URLQueryItem] = []
        
        if let subject = subject {
            queryItems.append(URLQueryItem(name: "subject", value: subject))
        }
        
        if let body = body {
            queryItems.append(URLQueryItem(name: "body", value: body))
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        return components.url
    }
    
    static func buildFeedbackURL(email: String, appName: String, additionalBody: String? = nil) -> URL? {
        let subject = "\(appName) Feedback"
        
        var bodyComponents: [String] = []
        
        if let additionalBody = additionalBody {
            bodyComponents.append(additionalBody)
        }
        
        bodyComponents.append("\n")
        bodyComponents.append(appName)
        bodyComponents.append("Version Number: \(Bundle.releaseVersionNumber ?? "Unknown")")
        bodyComponents.append("Build Number: \(Bundle.buildVersionNumber ?? "Unknown")")
        
        let body = bodyComponents.joined(separator: "\n")
        
        return buildMailtoURL(email: email, subject: subject, body: body)
    }
}
