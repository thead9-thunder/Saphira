//
//  SearchableModifier.swift
//  Cheers
//
//  Created by Thomas Headley on 6/16/25.
//

import SwiftUI

/// A reusable modifier that adds search functionality to any view.
/// 
/// This modifier encapsulates the common pattern of:
/// - Managing search text and presentation state
/// - Conditionally showing SearchView or the main content
/// - Adding the searchable modifier
/// 
/// Usage:
/// ```swift
/// MyContentView()
///     .searchable(searchMode: .drinks(Drink.favorites))
/// ```
struct SearchableModifier: ViewModifier {
    @State private var searchText = ""
    @State private var isSearchPresented = false
    
    let searchMode: SearchView.Mode
    
    init(searchMode: SearchView.Mode) {
        self.searchMode = searchMode
    }
    
    func body(content: Content) -> some View {
        VStack {
            if isSearchPresented {
                SearchView(searchText: searchText, mode: searchMode)
            } else {
                content
            }
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented)
    }
}

// MARK: - View Extension
extension View {
    /// Adds search functionality to a view using the specified search mode.
    /// 
    /// - Parameter searchMode: The search mode that determines what content is searchable
    /// - Returns: A view with search functionality added
    func searchable(searchMode: SearchView.Mode) -> some View {
        modifier(SearchableModifier(searchMode: searchMode))
    }
} 