//
//  IconPicker.swift
//  Cheers
//
//  Created by Thomas Headley on 6/26/25.
//

import Foundation
import SwiftUI

struct IconPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    var icon: Binding<Icon>
    
    @FocusState private var isEmojiTextFieldFocused: Bool
    @State private var emojiText: String = ""

    var body: some View {
        Form {
            selectedIconSection
            emojiSection
            sfSymbolSections
        }
        .navigationTitle("Select Icon")
        .toolbar { toolbar }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                dismiss()
            } label: {
                Label("Done", systemImage: "checkmark")
            }
        }
    }
    
    var selectedIconSection: some View {
        Section {
            HStack {
                Spacer()
                IconView(icon: icon.wrappedValue)
                    .font(.system(size: 60))
                    .minimumScaleFactor(0.1)
                    .frame(width: 60, height: 60)
                    .padding(20)
                    .selectableBackground(isSelected: true, cornerRadius: 25)
                Spacer()
            }
            .frame(maxWidth: .infinity, idealHeight: 140)
            .listRowBackground(Color.clear)
        }
    }
    
    var emojiSection: some View {
        Section {
            ZStack {
                TextField("", text: $emojiText)
                    .opacity(0)
                    .focused($isEmojiTextFieldFocused)
                    .keyboardType(.emoji ?? .asciiCapable)
                    .onChange(of: emojiText) { oldValue, newValue in
                        if !newValue.isEmpty {
                            icon.wrappedValue = .emoji(newValue)
                            emojiText = ""
                            isEmojiTextFieldFocused = false
                        }
                    }
                
                Button {
                    isEmojiTextFieldFocused = true
                } label: {
                    Text("Open Emoji Picker")
                }
            }
        } header: {
            Text("Emoji")
        }
    }
    
    var sfSymbolSections: some View {
        ForEach(SFSymbolCategory.all) { category in
            Section {
                SFSymbolPicker(icon: icon, sfSymbolCategory: category)
            } header: {
                Text(category.name)
            }
        }
    }
}

extension UIKeyboardType {
    static let emoji = UIKeyboardType(rawValue: 124)
}

struct SFSymbolPicker: View {
    var icon: Binding<Icon>
    let sfSymbolCategory: SFSymbolCategory
    
    private let columns = [
        GridItem(.adaptive(minimum: 30), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(sfSymbolCategory.sfSymbols, id: \.self) { sfSymbol in
                Button {
                    icon.wrappedValue = .sfSymbol(sfSymbol)
                } label: {
                    GeometryReader { geometry in
                        IconView(icon: .sfSymbol(sfSymbol))
                            .font(.title2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .selectableBackground(isSelected: isSelected(sfSymbol))
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
    
    private func isSelected(_ sfSymbol: String) -> Bool {
        if case .sfSymbol(let selectedSymbol) = icon.wrappedValue {
            return selectedSymbol == sfSymbol
        }
        return false
    }
}
