//
//  SensorDetailsChartStore.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SwiftUI
import SnsrWebApi
import SWAPICore

final class SensorDetailsChartStore: ObservableObject {
    // MARK: - Types
    
    enum Actions: FluxAction {
        case loaded(value: ObjectValueModel)
        case error
    }
    
    struct SensorDetailsModel: Identifiable {
        let id = UUID()
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
    @Published private(set) var model: SensorDetailsModel?
    
    // MARK: - Init
    init() {
        dispatcher?.register(actionType: SensorDetailsChartStore.Actions.self,
                             for: self)
    }
}

// MARK: - FluxStore
extension SensorDetailsChartStore: FluxStore {
    func onDispatch(with action: FluxAction) {
        guard let action = action as? Actions else { return }
        
        switch action {
        case .loaded(let values):
            onReceive(values)
        case .error:
            // TODO: - error handling
            return
        }
    }
    
    private func onReceive(_ value: ObjectValueModel) {
        model = SensorDetailsModel(objectId: value.objectId,
                                   receiveTime: value.objectReceiveTime,
                                   value: value.objectValue)
        
    }
}
