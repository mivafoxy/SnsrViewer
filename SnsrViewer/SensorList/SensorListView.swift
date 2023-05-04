//
//  SensorListView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI

struct SensorListView: View {
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout) {
                ForEach((0...1), id: \.self) { _ in
                    NavigationLink(
                        destination: {
                        SensorDetailsView()
                    }, label: {
                        SensorCellView()
                    })
                }
            }
        }
    }
}

struct SensorListView_Previews: PreviewProvider {
    static var previews: some View {
        SensorListView()
    }
}
