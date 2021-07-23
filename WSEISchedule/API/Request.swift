//
//  Request.swift
//  Offer Sniper
//
//  Created by Maksymilian Galas on 13/07/2021.
//

import UIKit

final class Request: Requestable {
    
    // MARK: Properties

    private let request: URLRequest
    private let debug: Bool

    private var dataSuccessCallback: ((Data?) -> Void)? = nil
    private var errorCallback: ((Error) -> Void)? = nil
    
    // MARK: Initialization
    
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
                    "\(key)=\(value.xWwwFormUrlEncoded)"
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

    init(url: URL, debug: Bool = false) {
        if debug {
            print(url.absoluteString)
        }

        self.request = URLRequest(url: url)
        self.debug = debug
    }
    
    // MARK: Methods

    func onDataSuccess(_ callback: @escaping (String) -> Void) -> Self {
        dataSuccessCallback = { [debug] data in
            let responseData: String
            if let data = data {
                responseData = String(data: data, encoding: .utf8) ?? ""
            } else {
                responseData = ""
            }

            if debug {
                print(responseData)
            }

            callback(responseData)
        }
        return self
    }

    func onImageDownloadSuccess(_ callback: @escaping (UIImage?) -> Void) -> Self {
        dataSuccessCallback = { [debug] data in
            let image: UIImage?
            if let data = data {
                image = UIImage(data: data)
            } else {
                image = nil
            }

            if debug {
                print(image as Any)
            }

            callback(image)
        }
        return self
    }

    func onError(_ callback: @escaping (Error) -> Void) -> Self {
        errorCallback = callback
        return self
    }

    func make() {
        let task = URLSession.shared.dataTask(with: request) { [request, dataSuccessCallback, errorCallback] (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                    errorCallback?(error)
                    return
                }

                fatalError("Data and error should never both be nil")
            }

            let url = request.url!
            let httpResponse = response as? HTTPURLResponse
            let fields = httpResponse?.allHeaderFields as? [String: String]
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields!, for: url)
            HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)

            dataSuccessCallback?(data)
        }

        task.resume()
    }

}

extension String {

    var xWwwFormUrlEncoded: String {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-._* ")

        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+") ?? ""
    }

}
