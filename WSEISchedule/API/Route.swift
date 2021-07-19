//
//  Route.swift
//  Offer Sniper
//
//  Created by Maksymilian Galas on 13/07/2021.
//

struct Route: Hashable {
    
    let path: String
    let method: HTTPMethod
    let headers: [String : String]
    let parameters: [String : AnyHashable]
    
    init(path: String, method: HTTPMethod, headers: [String : String] = [:], parameters: [String : AnyHashable] = [:]) {
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
    
}
