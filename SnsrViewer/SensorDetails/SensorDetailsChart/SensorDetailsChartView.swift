//
//  SensorDetailsChartView.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 04.05.2023.
//

import SwiftUI
import Charts

struct SensorDetailsChartView: View {
    private var data: [Amount] = [
        .init(month: "Январь", amount: 100.00),
        .init(month: "Февраль", amount: 100.00),
        .init(month: "Апрель", amount: 500.00),
        .init(month: "Май", amount: 120.00),
        .init(month: "Июнь", amount: 100.00),
        .init(month: "Июль", amount: 200.00),
        .init(month: "Август", amount: 120.00),
        .init(month: "Сентрябрь", amount: 100.00),
        .init(month: "Октябрь", amount: 200.00),
        .init(month: "Ноябрь", amount: 120.00),
        .init(month: "Декабрь", amount: 120.00)
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            Chart {
                ForEach(data) { datum in
                    BarMark(x: .value("Month", datum.month),
                            y: .value("Total", datum.amount))
                    .annotation(position: .top) {
                        Text(String(format: "%.3f", datum.amount))
                    }
                    .opacity(0.5)
                }
                
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel() {
                        if let stringValue = value.as(String.self) {
                            Text("\(stringValue)")
                                .font(.system(size: 20)) 
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in }
            }
            .frame(width: 100 * CGFloat(data.count))
        }
    }
}

struct SensorDetailsChartView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDetailsChartView()
    }
}
