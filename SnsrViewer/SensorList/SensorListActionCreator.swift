//
//  SensorListActionCreator.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SnsrWebApi
import SWAPICore

final class SensorListActionCreator {
    // MARK: - Properties
    
    @Injected private var dispatcher: FluxDispatcher?
    
    // MARK: - Actions
    
    func getDevices() {
        let getDeviceRequest = API.Device.GetApiDevice.Request()
        APIClient(baseURL: "http://192.168.1.54:44343")
            .makeRequest(getDeviceRequest) { [weak self] response in
                switch response.result {
                case .success(let responseValue):
                    if let devices = responseValue.success {
                        self?.dispatcher?.dispatch(action: SensorListStore.SensorAction.loaded(devices: devices))
                    } else {
                        self?.dispatcher?.dispatch(action: SensorListStore.SensorAction.error)
                    }
                case .failure:
                    self?.dispatcher?.dispatch(action: SensorListStore.SensorAction.error)
                }
            }
    }
}
