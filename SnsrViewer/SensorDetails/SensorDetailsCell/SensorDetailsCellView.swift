//
//  SensorDetailsCellView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI

struct SensorDetailsCellView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .neumorphic(.accentColor)
                .opacity(0.5)
                .frame(width: UIScreen.main.bounds.width - 10,
                       height: 125)
            HStack(spacing: 25) {
                Image("water")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50,
                           maxHeight: 50)
                VStack {
                    Text("Серийный номер")
                    Text("123456789")
                }
                VStack {
                    Text("Потребление")
                    Text("Число куб. м.")
                }
            }
            
        }
    }
}

extension RoundedRectangle {
    func neumorphic(_ color: Color) -> some View {
        self
            .fill(color)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
}

struct SensorDetailsCellView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDetailsCellView()
    }
}
