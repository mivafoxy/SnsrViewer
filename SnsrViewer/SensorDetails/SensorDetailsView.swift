//
//  SensorDetailsView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import Charts

struct SensorDetailsView: View {
    private let actionCreator = SensorDetailsActionCreator()
    @ObservedObject private var store: SensorDetailsStore
    
    init(model: SensorListStore.Device) {
        store = SensorDetailsStore(device: model)
    }
    
    var body: some View {
        makeDeviceView()
        ScrollView {
            makeValueView()
        }
        .refreshable {
            actionCreator.getSensorLastValue(deviceId: store.device.serial,
                                             objectId: SensorValueType.coldWater.rawValue)
            actionCreator.getSensorLastValue(deviceId: store.device.serial,
                                             objectId: SensorValueType.hotWater.rawValue)
        }
    }
}

struct SensorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

// MARK: - ViewBuilders
extension SensorDetailsView {
    @ViewBuilder
    func makeDeviceView() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .neumorphic(.teal)
                    .opacity(0.5)
                    .frame(height: 150)
                    .padding()
                HStack {
                    Image("water")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 50, maxHeight: 50)
                    VStack {
                        Text("Модель")
                        Text(store.device.modelName)
                            .foregroundColor(.black)
                    }
                    VStack {
                        Text("Серийный номер")
                        Text(store.device.serial)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func makeValueView() -> some View {
        switch store.viewState {
        case .idle, .loading:
            ProgressView("Загрузка").onAppear() {
                actionCreator.getSensorLastValue(deviceId: store.device.serial,
                                                 objectId: SensorValueType.coldWater.rawValue)
                actionCreator.getSensorLastValue(deviceId: store.device.serial,
                                                 objectId: SensorValueType.hotWater.rawValue)
            }
        case .finished:
            valueBody
                .onAppear {
                    Task {
                        if let hotWaterModel = store.howWaterModel {
                            try await actionCreator.saveValueToCache(
                                value: hotWaterModel,
                                device: store.device)
                        }
                        
                        if let coldWaterModel = store.coldWaterModel {
                            try await actionCreator.saveValueToCache(
                                value: coldWaterModel,
                                device: store.device)
                        }
                    }
                }
        case .error(let errorType):
            onError(errorType: errorType)
        case .cached:
            VStack {
                Text("Загружены кэшированные значения")
                valueBody
            }
        case .emptyResult:
            onError(errorType: .emptyCache)
        }
    }
    
    var valueBody: some View {
        VStack {
            makeColdWaterBody()
            makeHotWaterBody()
        }
    }
    
    @ViewBuilder
    func makeColdWaterBody() -> some View {
        if
            let coldWaterValue = store.coldWaterModel?.value,
            let coldWaterReceiveTime = store.coldWaterModel?.receiveTime {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .neumorphic(.cyan)
                    .opacity(0.5)
                    .frame(height: 150)
                    .padding()
                HStack {
                    Image("cold")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 50, maxHeight: 50)
                    VStack {
                        Text("Холодная вода")
                        Text("\(coldWaterValue) куб. м.")
                        Text("Время снятия показаний")
                        Text("\(coldWaterReceiveTime.description)")
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func makeHotWaterBody() -> some View {
        if
            let hotWaterValue = store.howWaterModel?.value,
            let hotWaterReceiveTime = store.howWaterModel?.receiveTime {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .neumorphic(.orange)
                    .opacity(0.5)
                    .frame(height: 150)
                    .padding()
                HStack {
                    Image("fire")
                    VStack {
                        Text("Горячая вода")
                        Text("\(hotWaterValue) куб. м.")
                        Text("Время снятия показаний")
                        Text("\(hotWaterReceiveTime.description)")
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    func onError(errorType: ErrorType) -> some View {
        switch errorType {
        case .networkError:
            ProgressView("Сервер недоступен, загрузка из кэша")
                .onAppear {
                    Task {
                        try await actionCreator.loadValueFromCache(
                            device: store.device,
                            objectId: SensorValueType.coldWater.rawValue)
                        try await actionCreator.loadValueFromCache(
                            device: store.device,
                            objectId: SensorValueType.hotWater.rawValue)
                    }
                }
        case .emptyCache:
            VStack {
                Text("Значения не найдены")
                
                Button {
                    actionCreator.getSensorLastValue(
                        deviceId: store.device.serial,
                        objectId: SensorValueType.coldWater.rawValue)
                    actionCreator.getSensorLastValue(
                        deviceId: store.device.serial,
                        objectId: SensorValueType.hotWater.rawValue)
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                
                Text("Нажмите, чтобы обновить")
            }
        }
    }
}
