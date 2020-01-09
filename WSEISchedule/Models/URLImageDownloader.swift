//
//  URLImageDownloader.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 20/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import Combine

final class URLImageDownloader: ObservableObject {
    var url: URL? {
        didSet {
            downloadImage()
        }
    }
    
    @Published var image: UIImage?
    
    init(url: URL?) {
        self.url = url
        downloadImage()
    }
    
    private func downloadImage() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        if let data = URLCache.shared.cachedResponse(for: request)?.data {
            image = UIImage(data: data)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response else { return }
                let cachedData = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: request)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
