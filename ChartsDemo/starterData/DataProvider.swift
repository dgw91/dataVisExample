//  DataProvider.swift
//  Created by Derrick Wilde on 2/7/24.

import Foundation
import SwiftUI
import Combine

class DataProvider {

    var alcoholData: [Beer] = []
    let dataService = DataService()
    
    func getAlchoholData() {
        dataService.getBeers().sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { value in
            self.alcoholData = value
        }).cancel()
    }
    /// Total sales for the last 30 days.
    var alcoholTotal: Int {
        self.alcoholData.map { Int($0.alcohol) ?? 0 }.reduce(0, +)
    }
    
    var last30DaysAverage: Double {
        Double(alcoholTotal / alcoholData.count)
    }
}
