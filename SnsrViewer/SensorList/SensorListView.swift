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
        .onAppear {
            actionCreator.getDevices()
        }
    }
}

struct SensorListView_Previews: PreviewProvider {
    static var previews: some View {
        SensorListView()
    }
}
