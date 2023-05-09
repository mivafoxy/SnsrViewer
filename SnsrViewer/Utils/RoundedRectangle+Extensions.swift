//
//  RoundedRectangle+Extensions.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 09.05.2023.
//

import SwiftUI

extension RoundedRectangle {
    func neumorphic(_ color: Color) -> some View {
        self
            .fill(color)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}
