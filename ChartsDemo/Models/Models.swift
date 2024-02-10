//
//  Beer.swift
//  ChartsDemo
//
//  Created by Derrick Wilde on 2/7/24.
//

import Foundation

struct Beer: Identifiable, Decodable {
    var id: Int
    var brand: String
    var name: String
    var style: String
    var hop: String
    var yeast: String
    var malts: String
    var ibu: String
    var alcohol: String
}

// MARK: - Welcome
struct User: Codable, Identifiable {
    let id: Int
    let uid, password, firstName, lastName: String
    let username, email: String
    let avatar: String
    let gender: String
    let phoneNumber: String
    let socialInsuranceNumber: String
    let dateOfBirth: String
    let employment: Employment
    let address: Address
    let creditCard: CreditCard
    let subscription: Subscription

    enum CodingKeys: String, CodingKey {
        case id, uid, password
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email, avatar, gender
        case phoneNumber = "phone_number"
        case socialInsuranceNumber = "social_insurance_number"
        case dateOfBirth = "date_of_birth"
        case employment, address
        case creditCard = "credit_card"
        case subscription
    }
}

// MARK: - Address
struct Address: Codable {
    let city: String
    let streetName: String
    let streetAddress: String
    let zipCode: String
    let state: String
    let country: String
    let coordinates: Coordinates

    enum CodingKeys: String, CodingKey {
        case city
        case streetName = "street_name"
        case streetAddress = "street_address"
        case zipCode = "zip_code"
        case state
        case country
        case coordinates
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, lng: Double
}

// MARK: - CreditCard
struct CreditCard: Codable {
    let ccNumber: String

    enum CodingKeys: String, CodingKey {
        case ccNumber = "cc_number"
    }
}

// MARK: - Employment
struct Employment: Codable {
    let title, keySkill: String

    enum CodingKeys: String, CodingKey {
        case title
        case keySkill = "key_skill"
    }
}

// MARK: - Subscription
struct Subscription: Codable {
    let plan, status, paymentMethod, term: String

    enum CodingKeys: String, CodingKey {
        case plan
        case status
        case paymentMethod = "payment_method"
        case term
    }
}


struct Appliance: Identifiable, Decodable {
    let id: Int
    let uid, brand, equipment: String
}
struct BloodType: Identifiable, Decodable {
    let id: Int
    let uid, type, rhFactor, group: String

    enum CodingKeys: String, CodingKey {
        case id, uid, type
        case rhFactor = "rh_factor"
        case group
    }
}

struct JSONData: Decodable {
    let beers: [Beer]
//    let bloodTypes: [BloodType]
//    let users: [User]
}
