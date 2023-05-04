//
//  SensorCellView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI

struct SensorCellView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .neumorphic(.teal)
                    .opacity(0.5)
                    .frame(height: 150)
                    .padding()
                Image("water")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50, maxHeight: 50)
            }
            Text("Some title")
        }
    }
}

struct SensorCellView_Previews: PreviewProvider {
    static var previews: some View {
        SensorCellView()
    }
}
