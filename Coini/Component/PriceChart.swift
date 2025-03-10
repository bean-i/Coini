//
//  PriceChart.swift
//  Coini
//
//  Created by 이빈 on 3/10/25.
//

import SwiftUI
import Charts

class ChartData: ObservableObject {
    @Published var chartPrices: [Double] = []
}

struct CoinPrice: Identifiable {
    let id = UUID()
    let time: Int
    let price: Double
}

struct PriceChart: View {
    
    @ObservedObject var chartData: ChartData
    
    var datas: [CoinPrice] {
        var result: [CoinPrice] = []
        for (index, price) in chartData.chartPrices.enumerated() {
            result.append(CoinPrice(time: index, price: price))
        }
        return result
    }
    
    var body: some View {
        Chart(datas) { data in
            LineMark(
                x: .value("", data.time),
                y: .value("", data.price)
            )
            .interpolationMethod(.catmullRom)
    
            AreaMark(
                x: .value("", data.time),
                yStart: .value("", datas.map { $0.price }.min() ?? 0),
                yEnd: .value("", data.price)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.linearGradient(colors: [.customBlue.opacity(0.3), .customBlue.opacity(0.8)], startPoint: .bottom, endPoint: .top))
        }
        .chartYScale(domain: (datas.map { $0.price }.min() ?? 0)...(datas.map { $0.price }.max() ?? 0))
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .frame(height: 200)
    }
}
