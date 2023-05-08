//
//  SensorDetailsChartView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import Charts
import SWAPICore

struct SensorDetailsChartView: View {
    
    // MARK: - Properties
    
    private let actionCreator = SensorDetailsActionCreator()
    @ObservedObject private var store = SensorDetailsChartStore()
    
    init(device: SensorListStore.Device) {
        actionCreator.getSensorLastValue(deviceId: device.serial, objectId: 3)
    }
    
    // MARK: - View
    
    var body: some View {
        HStack {
            Text("\(store.model?.value ?? 0.0) куб.м.")
        }
    }
}

struct SensorDetailsChartView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
