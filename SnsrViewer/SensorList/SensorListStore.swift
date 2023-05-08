//
//  SensorListStore.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SwiftUI
import SnsrWebApi
import SWAPICore

final class SensorListStore: ObservableObject {
    // MARK: - Types
    
    enum SensorType: Int {
        case WaterSensor = 1
    }
    
    enum SensorAction: FluxAction {
        case loaded(devices: [DeviceModel])
        case error
    }
    
    struct Device: Identifiable {
        let id = UUID()
        let modelName: String
        let modelType: Int
        let modelUuid: String
        let serial: String
        
        init?(modelName: String?,
              modelType: Int?,
              modelUuid: String?,
              serial: String?
        ) {
            guard
                let modelName = modelName,
                let modelType = modelType,
                let modelUuid = modelUuid,
                let serial = serial
            else {
                return nil
            }
            
            self.modelName = modelName
            self.modelType = modelType
            self.modelUuid = modelUuid
            self.serial = serial
        }
    }
    
    // MARK: - Properties
    
    @Injected private var dispatcher: FluxDispatcher?
    @Published private(set) var models: [Device] = []
    
    // MARK: - Init
    
    init() {
        dispatcher?.register(actionType: SensorListStore.SensorAction.self, for: self)
    }
}

// MARK: - FluxStore
extension SensorListStore: FluxStore {
    func onDispatch(with action: FluxAction) {
        guard let action = action as? SensorAction else { return }
        
        switch action {
        case .loaded(let devices):
            onRecieve(devices)
        case .error:
            // TODO: - show error and try to load cache
            return
        }
    }
    
    private func onRecieve(_ devices: [DeviceModel]) {
        models = devices.compactMap { device in
            if SensorType(rawValue: device.deviceModelType ?? -1) == SensorType.WaterSensor {
                return Device(modelName: device.deviceModelName,
                              modelType: device.deviceModelType,
                              modelUuid: device.deviceModelUuid,
                              serial: device.deviceSerial)
            } else {
                return nil
            }
        }
    }
}
