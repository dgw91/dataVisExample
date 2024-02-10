//
//  ContentView.swift
//  ChartsDemo
//
//  Created by Derrick Wilde on 2/7/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var selection = 2
    var cancellable: AnyCancellable?
    var vm = ContentViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            ChartsTab(vm: ContentViewModel())
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.doc.horizontal")
                }
                .tag(2)
        }
    }
}

struct MenuTab: View {
    var body: some View {
        VStack {
            Image(systemName: "fork.knife.circle.fill")
                .font(.largeTitle)
            Text("Menu")
                .font(.title2.bold())
        }
        .foregroundStyle(.secondary)
    }
}

struct ChartsTab: View {
    @ObservedObject var vm: ContentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationSplitView {
            Section {
                AlcoholPercentageChart(beers: vm.beers)
            }.onAppear {
                vm.getBeerData()
            }
            Section {
                BloodTypePieChart(bloodTypes: vm.bloodData, typeAs: vm.typeAs, typeBs: vm.typeBs, typeABs: vm.typeABs, typeOs: vm.typeOs)
            }.onAppear {
                vm.getBloodTypeData()
            }
            .navigationTitle("Charts Demo")
            #if !os(macOS)
            .listStyle(.insetGrouped)
            #endif
        } detail: {
            // Detail view content
        }
    }
}
#Preview {
    ContentView()
}

