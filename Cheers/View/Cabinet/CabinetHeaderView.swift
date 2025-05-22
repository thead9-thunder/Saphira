//
//  CabinetHeaderView.swift
//  Cheers
//
//  Created by Thomas Headley on 5/19/25.
//

import Foundation
import SwiftUI

struct CabinetHeaderView: View {
    let cabinet: Cabinet

    var body: some View {
        Text(cabinet.name)
    }
}
