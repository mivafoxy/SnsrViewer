//
//  SensorDetailsView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import Charts

struct SensorDetailsView: View {
    private let model: SensorListStore.Device
    
    init(model: SensorListStore.Device) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            SensorDetailsCellView()
            SensorDetailsChartView(device: model)
        }
        .backplateBackground()
    }
}

struct SensorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

