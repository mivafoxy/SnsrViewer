//
//  SensorDetailsStore.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import SwiftUI
import SWAPICore

final class SensorDetailsStore: ObservableObject {
    // MARK: - Types
    
    enum SensorDetailsAction: FluxAction {
        
    }
    
    
    
    // MARK: - Properties
    
    // MARK: - Init
    
}

// MARK: - FluxStore
extension SensorDetailsStore: FluxStore {
    func onDispatch(with action: SWAPICore.FluxAction) {
        return
    }
}
