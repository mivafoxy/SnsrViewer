//
//  SensorCellStore.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SwiftUI

final class SensorCellStore: ObservableObject {
    @Published private(set) var model: SensorListStore.Device
    
    init(_ model: SensorListStore.Device) {
        self.model = model
    }
}
