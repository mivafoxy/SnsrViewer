//
//  SensorDetailsChartStore.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SwiftUI
import SnsrWebApi
import SWAPICore

enum SensorValueType: Int {
    case coldWater = 3
    case hotWater = 4
}

final class SensorDetailsStore: ObservableObject {
    // MARK: - Types
    
    enum Actions: FluxAction {
        case loaded(value: ObjectValueModel)
        case loadedFromCache(value: SensorDetailsModel)
        case error(ErrorType)
    }
    
    struct SensorDetailsModel: Codable {
        let objectId: Int
        let receiveTime: Date
        let value: Double
        
        init?(objectId: Int?,
              receiveTime: String?,
              value: String?
        ) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            
            guard
                let objectId = objectId,
                let receiveTime = dateFormatter.date(from: receiveTime ?? ""),
                let value = Double(value?.replacingOccurrences(of: ",", with: ".") ?? "")
            else {
                return nil
            }
            
            self.objectId = objectId
            self.receiveTime = receiveTime
            self.value = value
        }
    }
    
    // MARK: - Properties
    @Injected private var dispatcher: FluxDispatcher?
    @Published private(set) var coldWaterModel: SensorDetailsModel?
    @Published private(set) var howWaterModel: SensorDetailsModel?
    @Published private(set) var device: SensorListStore.Device
    @Published private(set) var viewState: ViewState = .idle
    
    // MARK: - Init
    init(device: SensorListStore.Device) {
        self.device = device
        dispatcher?.register(actionType: SensorDetailsStore.Actions.self, for: self)
    }
}

// MARK: - FluxStore
extension SensorDetailsStore: FluxStore {
    func onDispatch(with action: FluxAction) {
        guard let action = action as? Actions else { return }
        
        DispatchQueue.main.async {
            switch action {
            case .loaded(let value):
                self.onReceive(value)
            case .error(let errorType):
                self.viewState = .error(errorType: errorType)
            case .loadedFromCache(let value):
                self.onReceiveFromCache(value)
            }
        }
    }
    
    private func onReceive(_ value: ObjectValueModel) {
        if value.objectId == SensorValueType.coldWater.rawValue {
            coldWaterModel = SensorDetailsModel(objectId: value.objectId,
                                                receiveTime: value.objectReceiveTime,
                                                value: value.objectValue)
        } else if value.objectId == SensorValueType.hotWater.rawValue {
            howWaterModel = SensorDetailsModel(objectId: value.objectId,
                                               receiveTime: value.objectReceiveTime,
                                               value: value.objectValue)
        }
        
        viewState = .finished
    }
    
    private func onReceiveFromCache(_ value: SensorDetailsModel) {
        if value.objectId == SensorValueType.hotWater.rawValue {
            howWaterModel = value
        } else if value.objectId == SensorValueType.coldWater.rawValue {
            coldWaterModel = value
        }
        
        viewState = .cached
    }
}
