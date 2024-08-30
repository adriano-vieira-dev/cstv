//
//  View+Extensions.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
}
