//
//  AppDispatcher.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 08.05.2023.
//

import Foundation
import SWAPICore


final class AppDispatcher: FluxDispatcher {
    private var actionToStore = [String : any FluxStore]()
    
    func register(actionType: FluxAction.Type, for store: any FluxStore) {
        let name = String(reflecting: actionType)
        actionToStore[name] = store
    }
    
    func dispatch(action: FluxAction) {
        let name = String(reflecting: type(of: action).self)
        actionToStore[name]?.onDispatch(with: action)
    }
}
