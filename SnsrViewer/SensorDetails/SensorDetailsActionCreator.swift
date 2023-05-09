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
    private let cacheFileName = "SensorValueCache"
    @Injected private var dispatcher: FluxDispatcher?
    @Injected private var cacheService: CacheServiceProtocol?
    
    // MARK: - Actions
    
    func getSensorLastValue(deviceId: String, objectId: Int) {
        let request = API
            .Device
            .GetApiDeviceDeviceSerialandobjectId
            .Request(deviceSerial: deviceId, objectId: objectId)
        
        // TODO: - вынести baseURL в константы
        APIClient
            .default
            .makeRequest(request) { [weak self] response in
                switch response.result {
                case .success(let responseValue):
                    if let value = responseValue.success {
                        self?.dispatcher?.dispatch(action: SensorDetailsStore.Actions.loaded(value: value))
                    } else {
                        self?.dispatcher?.dispatch(action: SensorDetailsStore.Actions.error(.networkError))
                    }
                case .failure:
                    self?.dispatcher?.dispatch(action: SensorDetailsStore.Actions.error(.networkError))
                }
            }
    }
    
    func saveValueToCache(value: SensorDetailsStore.SensorDetailsModel,
                          device: SensorListStore.Device
    ) async throws {
        try await cacheService?.saveToCache(data: value, fileName: "\(device.serial)_\(cacheFileName)_\(value.objectId)")
    }
    
    func loadValueFromCache(device: SensorListStore.Device,
                            objectId: Int
    ) async throws {
        try await cacheService?.loadFromCache(fileName: "\(device.serial)_\(cacheFileName)_\(objectId)"
        ) { [weak self] (result: CacheResult<SensorDetailsStore.SensorDetailsModel>) in
            switch result {
            case .successLoad(let model):
                self?.dispatcher?
                    .dispatch(
                        action: SensorDetailsStore.Actions
                            .loadedFromCache(value: model))
            case .failure:
                self?.dispatcher?
                    .dispatch(
                        action: SensorDetailsStore.Actions
                            .error(.emptyCache))
            }
        }
    }
}
