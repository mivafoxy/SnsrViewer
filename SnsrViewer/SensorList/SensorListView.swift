//
//  SensorListView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI

struct SensorListView: View {
    // MARK: - Properties
    @ObservedObject private var store: SensorListStore = SensorListStore()
    private var actionCreator: SensorListActionCreator = SensorListActionCreator()
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        onStateChange()
    }
}

struct SensorListView_Previews: PreviewProvider {
    static var previews: some View {
        SensorListView()
    }
}

// MARK: - View builders
extension SensorListView {
    @ViewBuilder
    func onStateChange() -> some View {
        switch store.viewState {
        case .idle, .loading:
            ProgressView("Загрузка").onAppear {
                actionCreator.getDevices()
            }
        case .finished:
            sensorsBody
                .onAppear {
                    Task {
                        try await actionCreator.saveDevicesToCache(
                            devices: store.models)
                    }
                }
                .refreshable {
                    actionCreator.getDevices()
                }
        case .error(let errorType):
            onError(errorType: errorType)
        case .cached:
            VStack {
                Text("Загружены кэшированные значения")
                sensorsBody
                    .refreshable {
                        actionCreator.getDevices()
                    }
            }
        case .emptyResult:
            onError(errorType: .emptyCache)
        }
    }
    
    var sensorsBody: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout) {
                ForEach(store.models, id: \.id) { model in
                    NavigationLink(
                        destination: {
                            SensorDetailsView(model: model)
                        }, label: {
                            SensorCellView(model: model)
                        })
                }
            }
        }
    }
    
    @ViewBuilder
    func onError(errorType: ErrorType) -> some View {
        switch errorType {
        case .networkError:
            ProgressView("Сервер недоступен, загрузка из кэша")
                .onAppear {
                    Task {
                        try await actionCreator.getCachedDevices()
                    }
                }
        case .emptyCache:
            VStack {
                Text("Устройства не найдены")
                
                Button {
                    actionCreator.getDevices()
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            actionCreator.getDevices()
                        }
                }
                
                Text("Нажмите, чтобы обновить")
            }
        }
    }
}
