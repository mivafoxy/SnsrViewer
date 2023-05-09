//
//  ViewState.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 09.05.2023.
//

enum ViewState {
    case idle
    case loading
    case finished
    case error(errorType: ErrorType)
    case cached
    case emptyResult
}

enum ErrorType {
    case networkError
    case emptyCache
}
