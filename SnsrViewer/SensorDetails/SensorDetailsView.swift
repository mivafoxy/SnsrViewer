//
//  SensorDetailsView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import Charts

struct SensorDetailsView: View {
    @ObservedObject private var store: SensorDetailsStore
    
    init(model: SensorListStore.Device) {
        store = SensorDetailsStore(device: model)
    }
    
    var body: some View {
        VStack {
            
        }
    }
}

struct SensorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

