//
//  SettingsView.swift
//  Cheers
//
//  Created by Thomas Headley on 6/8/25.
//

import Foundation
import StoreKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            List {
                contactSection
                legalSection
                appStoreSection
                appInfoSection
            }
        }
        .navigationTitle("Settings")
        .toolbar { toolbar }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Label("Done", systemImage: "xmark")
            }
        }
    }
    
    private var contactSection: some View {
        Section {
            if let mailtoURL = MailtoURLBuilder.buildFeedbackURL(
                email: "feedback@thunderingdragon.com",
                appName: Cheers.appName
            ) {
                Link(destination: mailtoURL) {
                    Label("Send Feedback", systemImage: "paperplane")
                }
            }
            
            Button {
                requestReview()
            } label: {
                Label("Rate & Review", systemImage: "star.bubble")
            }
        } header: {
            Text("Contact")
        }
    }
    
    private var legalSection: some View {
        Section {
            if let privacyPolicyURL = URL(string: Cheers.privacyPolicy) {
                Link(destination: privacyPolicyURL) {
                    HStack {
                        Label("Privacy Policy", systemImage: "hand.raised")
                        Spacer()
                        Image(systemName: "arrow.up.forward")
                    }
                }
            }
            
            if let termsOfUseURL = URL(string: Cheers.termsOfUse) {
                Link(destination: termsOfUseURL) {
                    HStack {
                        Label("Terms of Use", systemImage: "doc.text")
                        Spacer()
                        Image(systemName: "arrow.up.forward")
                    }
                }
            }
        } header: {
            Text("Legal")
        }
    }
    
    var appStoreSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await AppStore.sync()
                    } catch {
                        errorMessage = ErrorUtilities.userFriendlyMessage(for: error)
                        showingError = true
                    }
                }
            } label: {
                Label("Restore Purchases", systemImage: "arrow.clockwise")
            }
            .alert("Restore Failed", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    var appInfoSection: some View {
        Section {
        } footer: {
            HStack {
                Spacer()
                VStack {
                    Text(Cheers.appName)
                    HStack {
                        if let versionNumber = Bundle.releaseVersionNumber {
                            Text("Version \(versionNumber)")
                        }
                        if let buildNumber = Bundle.buildVersionNumber {
                            Text("Build \(buildNumber)")
                        }
                    }
                }
                Spacer()
            }
            .font(.body)
        }
    }
}
