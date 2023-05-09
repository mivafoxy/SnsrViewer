//
//  SnsrViewerApp.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import SWAPICore

@main
struct SnsrViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class Configurator {
    static let shared = Configurator()
    
    private init() {}
    
    func setup() {
        setupAppDispatcher()
        setupCacheService()
    }
    
    private func setupAppDispatcher() {
        let appDispatcher: FluxDispatcher = AppDispatcher()
        ServiceLocator.shared.addService(service: appDispatcher)
    }
    
    private func setupCacheService() {
        let cacheService: CacheServiceProtocol = FileCacheService()
        ServiceLocator.shared.addService(service: cacheService)
    }
}
