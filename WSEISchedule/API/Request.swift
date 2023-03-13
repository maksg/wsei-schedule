//
//  Request.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import UIKit

final class Request: Requestable {
    
    // MARK: - Properties

    private let request: URLRequest
    private let debug: Bool
    
    // MARK: - Initialization
    
    init(url: URL, endpoint: Routable, debug: Bool = false) {
        let method = endpoint.route.method
        let parameters = endpoint.route.parameters

        var headers = endpoint.route.headers
        headers["Content-Type"] = "application/x-www-form-urlencoded"

        let urlString = "\(url)\(endpoint.route.path)"
        var urlComponents = URLComponents(string: urlString)
        
        if method == .get && !parameters.isEmpty {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents?.url else { fatalError("Invalid URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if method != .get {
            if headers["Content-Type"] == "application/json" {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            } else {
                let stringParameters = parameters as NSDictionary as! [String: String]
                let encodedParameters = stringParameters.map { (key, value) -> String in
                    "\(key)=\(value.formUrlEncoded)"
                }
                request.httpBody = encodedParameters.joined(separator: "&").data(using: .utf8)
            }
        }

        if debug {
            print(url.absoluteString)
            print(method.rawValue)
            print(headers)
            print(parameters)
        }

        self.request = request
        self.debug = debug
    }
    
    // MARK: - Methods

    func make() async throws -> String {
        let (data, _) = try await URLSession.shared.data(for: request)
        let responseData = String(data: data, encoding: .utf8) ?? ""
        if debug {
            print(responseData)
        }
        return responseData
    }

}
