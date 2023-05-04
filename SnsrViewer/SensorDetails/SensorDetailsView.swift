//
//  SensorDetailsView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import Charts

struct Amount: Identifiable {
    var month: String
    var amount: Double
    var id = UUID()
}

struct SensorDetailsView: View {
    var body: some View {
        VStack {
            SensorDetailsCellView()
            SensorDetailsChartView()
        }
        .backplateBackground()
    }
}

struct SensorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDetailsView()
    }
}

