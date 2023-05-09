//
//  ContentView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI

struct ContentView: View {
    init() {
        Configurator.shared.setup()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SensorListView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
