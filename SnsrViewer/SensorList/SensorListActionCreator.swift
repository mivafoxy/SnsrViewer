//
//  SensorListActionCreator.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import Foundation
import SnsrWebApi
import SWAPICore

final class SensorListActionCreator {
    // MARK: - Properties
    
    @Injected private var dispatcher: FluxDispatcher?
    @Injected private var cacheService: CacheServiceProtocol?
    private let cacheFileName: String = "SensorListCache"
    
    // MARK: - Actions
    
    func getDevices() {
        let getDeviceRequest = API.Device.GetApiDevice.Request()
        APIClient
            .default
            .makeRequest(getDeviceRequest) { [weak self] response in
                switch response.result {
                case .success(let responseValue):
                    if let devices = responseValue.success {
                        self?.dispatcher?.dispatch(action: SensorListStore.SensorAction.loaded(devices: devices))
                    } else {
                        self?.dispatcher?
                            .dispatch(
                                action: SensorListStore.SensorAction.error(.networkError))
                    }
                case .failure:
                    self?.dispatcher?
                        .dispatch(
                            action: SensorListStore.SensorAction.error(.networkError))
                }
            }
    }
    
    func getCachedDevices() async throws {
        try await cacheService?
            .loadFromCache(fileName: cacheFileName
            ) { [weak self] (result: CacheResult<[SensorListStore.Device]>) in
                switch result {
                case .successLoad(let devices):
                    self?.dispatcher?
                        .dispatch(
                            action: SensorListStore.SensorAction
                                .loadedFromCache(devices: devices))
                case .failure:
                    self?.dispatcher?
                        .dispatch(
                            action: SensorListStore.SensorAction
                                .error(.emptyCache))
                }
            }
    }
    
    func saveDevicesToCache(devices: [SensorListStore.Device]) async throws {
        try await cacheService?.saveToCache(data: devices, fileName: cacheFileName)
    }
}
