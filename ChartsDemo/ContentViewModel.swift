//
//  ContentViewController.swift
//  ChartsDemo
//
//  Created by Derrick Wilde on 2/7/24.
//

import Foundation
import Combine

enum DataType {
    case users
    case beer
    case appliances
    case bloodType
}

class ContentViewModel: ObservableObject {
    let api = DataService()
    @Published var beers: [Beer] = []
    @Published var users: [User] = []
    @Published var bloodData: [BloodType] = []
    @Published var typeAs: [BloodType] = []
    @Published var typeBs: [BloodType] = []
    @Published var typeABs: [BloodType] = []
    @Published var typeOs: [BloodType] = []
    @Published var premiumCount: [User] = []
    @Published var diamondCount: [User] = []
    @Published var goldCount: [User] = []
    @Published var silverCount: [User] = []
    @Published var freeCount: [User] = []

    private var cancellables = Set<AnyCancellable>()
    
    func getBeerData() {
        api.getBeers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("API call failed with error: \(error)")
                }
            } receiveValue: { [weak self] beers in
                self?.beers = beers
            }
            .store(in: &cancellables)
    }
    
    func getBloodTypeData() {
        api.getBloodType()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("API call failed with error: \(error)")
                }
            } receiveValue: { [weak self] bloodData in
                self?.bloodData = bloodData
                self?.splitBloodData()
            }
            .store(in: &cancellables)
    }
    func splitBloodData() {
        self.bloodData.forEach { bloodData in
            if bloodData.type == "A" {
                typeAs.append(bloodData)
            } else if bloodData.type == "B" {
                typeBs.append(bloodData)
            } else if bloodData.type == "AB" {
                typeABs.append(bloodData)
            } else if bloodData.type == "O" {
                typeOs.append(bloodData)
            }
        }
    }
    
    func getUserData() {
        api.getUsers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("API call failed with error: \(error)")
                }
            } receiveValue: { [weak self] userData in
                self?.users = userData
                for user in userData {
                    print(user.subscription.plan)
                }
            }
            .store(in: &cancellables)
    }
    func splitUserData() {
        self.users.forEach { user in
            if user.subscription.plan == "Premium" {
                premiumCount.append(user)
            } else if user.subscription.plan == "Silver" {
                diamondCount.append(user)
            } else if user.subscription.plan == "Diamond" {
                goldCount.append(user)
            } else if user.subscription.plan == "Gold"{
                silverCount.append(user)
            } else if user.subscription.plan == "Free Trial"{
                freeCount.append(user)
            }
        }
    }
}
