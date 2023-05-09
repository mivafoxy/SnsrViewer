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
        let task = Task<[SensorListStore.Device]?, Error> { [weak self] in
            guard let fileURL = try self?.fileURL() else {
                self?.dispatcher?
                    .dispatch(
                        action: SensorListStore.SensorAction
                            .error(.emptyCache))
                return nil
            }
            
            guard let data = try? Data(contentsOf: fileURL) else {
                self?.dispatcher?
                    .dispatch(
                        action: SensorListStore.SensorAction
                            .error(.emptyCache))
                return nil
            }
            
            let devices = try JSONDecoder()
                .decode([SensorListStore.Device].self,
                        from: data)
            
            return devices
        }
        
        guard let devices = try await task.value else {
            self.dispatcher?
                .dispatch(
                    action: SensorListStore.SensorAction
                        .error(.emptyCache))
            return
        }
        
        dispatcher?.dispatch(
            action: SensorListStore.SensorAction
                .loadedFromCache(devices: devices))
    }
    
    func saveDevicesToCache(devices: [SensorListStore.Device]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(devices)
            let outfile = try fileURL()
            try data.write(to: outfile)
        }
        
        _ = try await task.value
    }
    
    func fileURL() throws -> URL {
        return try FileManager
            .default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: false)
            .appendingPathComponent("\(cacheFileName).data")
    }
}
