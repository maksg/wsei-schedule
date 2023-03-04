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
    
    @DispatchMainPublished var image: UIImage?
    private let customCacheRequest: URLRequest?
    
    init(url: URL?, customCacheRequest: URLRequest? = nil) {
        self.url = url
        self.customCacheRequest = customCacheRequest
        downloadImage()
    }
    
    private func downloadImage() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        let cacheRequest = customCacheRequest ?? request
        if let data = URLCache.shared.cachedResponse(for: cacheRequest)?.data {
            image = UIImage(data: data)
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, let response = response else { return }
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: cacheRequest)
            self?.image = UIImage(data: data)
        }.resume()
    }
}
