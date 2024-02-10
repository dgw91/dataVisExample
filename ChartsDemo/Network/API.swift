//
//  API.swift
//  ChartsDemo
//
//  Created by Derrick Wilde on 2/7/24.
//

import Foundation
import Combine

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var responseType: String { get }
    //Would not normally be part of base protocol. Would be paramenters in genereal
    var amountOfData: String { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
}

enum DataSetSize: String {
    case ten
    case hundred
    case thousand
}

enum DataEndpoint: APIEndpoint {
    
    case getBeers
    case getAppliances
    case getBloodTypes
    case getUsers
    
    var baseURL: URL {
        guard let url = URL(string: "https://random-data-api.com/api/v2/") else {
            fatalError("Unable to create url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getBeers:
            return "beers"
        case .getAppliances:
            return "appliances"
        case .getBloodTypes:
            return "blood_types"
        case .getUsers:
            return "users"
        }
    }
    
    var method: HTTPMethod {
        //would be switched on actual usage if in a real app
        switch self {
        default:
            return .get
        }
    }
    
    var amountOfData: String {
        switch self {
        default:
            return "100"
        }
    }
    
    var responseType: String {
        switch self {
        default:
            return "json"
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
        var queryItems = [URLQueryItem]()
        if endpoint.path == "beers" {
            queryItems = [URLQueryItem(name: "size", value: "3"), URLQueryItem(name: "response_type", value: endpoint.responseType)]

        } else {
            queryItems = [URLQueryItem(name: "size", value: endpoint.amountOfData), URLQueryItem(name: "response_type", value: endpoint.responseType)]
        }
        var url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        url = url.appending(queryItems: queryItems)
        let request = URLRequest(url: url)
              
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

protocol DataServiceProtocol {
    func getBeers() -> AnyPublisher<[Beer], Error>
    func getAppliances() -> AnyPublisher<[Appliance], Error>
    func getBloodType() -> AnyPublisher<[BloodType], Error>
    func getUsers() -> AnyPublisher<[User], Error>
}

class DataService: DataServiceProtocol {
    
    let apiClient = URLSessionAPIClient<DataEndpoint>()
    
    func getBeers() -> AnyPublisher<[Beer], Error> {
        return apiClient.request(.getBeers)
    }
    func getAppliances() -> AnyPublisher<[Appliance], Error> {
        return apiClient.request(.getAppliances)
    }
    func getBloodType() -> AnyPublisher<[BloodType], Error> {
        return apiClient.request(.getBloodTypes)
    }
    func getUsers() -> AnyPublisher<[User], Error> {
        return apiClient.request(.getUsers)
    }
}
