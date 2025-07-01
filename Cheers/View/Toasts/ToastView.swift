//
//  ToastView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/8/25.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let toast: Toast
    let onDismiss: () -> Void
    
    @State private var offset: CGFloat = -200
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack {
            IconView(icon: toast.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title)
                    .font(.headline)
                
                Text(toast.message)
                    .font(.subheadline)
                    .opacity(0.9)
            }
                        
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption)
                    .opacity(0.7)
            }
        }
        .foregroundStyle(toast.type.foregroundColor)
        .padding()
        .background(toast.type.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
        .offset(y: offset)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                offset = 0
                opacity = 1
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}

struct ToastOverlay: View {
    @ObservedObject var toastManager: ToastManager
    
    var body: some View {
        ZStack {
            if toastManager.isShowingToast, let toast = toastManager.currentToast {
                VStack {
                    ToastView(toast: toast) {
                        toastManager.dismissToast()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1000)
            }
        }
    }
}
