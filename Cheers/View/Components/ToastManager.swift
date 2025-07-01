//
//  ToastManager.swift
//  Cheers
//
//  Created by Thomas Headley on 6/8/25.
//

import Foundation
import SwiftUI

@MainActor
class ToastManager: ObservableObject {
    @Published var currentToast: Toast?
    @Published var isShowingToast = false
    
    static let shared = ToastManager()
    
    private init() {}
    
    func showToast(_ toast: Toast) {
        currentToast = toast
        isShowingToast = true
        
        // Auto-dismiss after 3 seconds
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
            dismissToast()
        }
    }
    
    func dismissToast() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isShowingToast = false
        }
        
        // Clear the toast after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentToast = nil
        }
    }
}

struct Toast: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let icon: Icon
    let type: ToastType
    
    enum ToastType {
        case success(backgroundColor: Color, foregroundColor: Color)
        
        var backgroundColor: Color {
            switch self {
            case .success(let backgroundColor, _):
                return backgroundColor
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .success(_, let foregroundColor):
                return foregroundColor
            }
        }
    }
} 
