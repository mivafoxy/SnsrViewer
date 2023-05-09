//
//  SensorDetailsActionCreator.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SnsrWebApi
import SWAPICore

final class SensorDetailsActionCreator {
    // MARK: - Properties
    @Injected private var dispatcher: FluxDispatcher?
    
    // MARK: - Actions
    
    func getSensorLastValue(deviceId: String, objectId: Int) {
        let request = API
            .Device
            .GetApiDeviceDeviceSerialandobjectId
            .Request(deviceSerial: deviceId, objectId: objectId)
        
        // TODO: - вынести baseURL в константы
        APIClient(baseURL: "http://192.168.1.54:44343")
            .makeRequest(request) { [weak self] response in
                switch response.result {
                case .success(let responseValue):
                    if let value = responseValue.success {
                        self?.dispatcher?.dispatch(action: SensorDetailsStore.Actions.loaded(value: value))
                    } else {
                        self?.dispatcher?.dispatch(action: SensorDetailsStore.Actions.error)
                    }
                case .failure:
                    self?.dispatcher?.dispatch(action: SensorDetailsStore.Actions.error)
                }
            }
    }
}
