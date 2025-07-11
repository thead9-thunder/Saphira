//
//  ValidatedField.swift
//  Saphira
//
//  Created by Thomas Headley on 7/10/25.
//

import Foundation
import SwiftUI

public struct ValidatedField: ViewModifier {
  private var isValid: Bool
  private var invalidNotice: String
  
  public init(isValid: Bool, invalidNotice: String) {
    self.isValid = isValid
    self.invalidNotice = invalidNotice
  }
  
  public init(isValid: Bool, invalidNotice: InvalidNotice) {
    self.init(isValid: isValid, invalidNotice: invalidNotice.displayName)
  }
  
  public func body(content: Content) -> some View {
    VStack(alignment: .leading) {
      content
      if !isValid {
        Text(invalidNotice)
          .foregroundStyle(.red)
      }
    }
  }
  
  public enum InvalidNotice {
    case required
    case number
    
    var displayName: String {
      switch self {
      case .required:
        "* Required"
      case .number:
        "Must be a number"
      }
    }
  }
}

public extension View {
  func validatedField(isValid: Bool, invalidNotice: String) -> some View {
    modifier(ValidatedField(isValid: isValid, invalidNotice: invalidNotice))
  }
  
  func validatedField(isValid: Bool, invalidNotice: ValidatedField.InvalidNotice) -> some View {
    modifier(ValidatedField(isValid: isValid, invalidNotice: invalidNotice))
  }
}
