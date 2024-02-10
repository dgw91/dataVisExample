import Charts
import SwiftUI

struct AlcoholPercentageChart: View {
    var beers: [Beer]
    
    var body: some View {
        return Chart() {
            ForEach(beers) { beer in
                PointMark(
                    x: .value("Beer", beer.name),
                    y: .value("Alc%", beer.alcohol)
                )
            }
        }
    }
}

struct BloodTypePieChart: View {
    var bloodTypes: [BloodType]
    var typeAs: [BloodType]
    var typeBs: [BloodType]
    var typeABs: [BloodType]
    var typeOs: [BloodType]
    var data: [(type: String, amount: Int)] {
        [(type: "TypeA", amount: typeAs.count),
         (type: "TypeB", amount: typeBs.count),
         (type: "TypeAB", amount: typeABs.count),
         (type: "TypeO", amount: typeOs.count),
        ]
    }
    var body: some View {
        GroupBox ( "Blood Types") {
            Chart(data, id: \.type) { dataItem in
                SectorMark(angle: .value("Type", dataItem.amount),
                           innerRadius: .ratio(0.5),
                           angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(by: .value("Type", dataItem.type))
            }
        }
    }
}
//struct UserChart: View {
//    var users: [User]
//    var golds: [User]
//    var premiums: [User]
//    var silvers: [User]
//    var diamonds: [User]
//    var free: [User]
//
//    var body: some View {
//        GroupBox ( "Memberships") {
//            Chart(users) {
//                BarMark(
//                    x: .value("Gold", golds.count),
//                    y: .value("Step Count", $0.steps)
//                )
//            }
//        }
//    }
//}
