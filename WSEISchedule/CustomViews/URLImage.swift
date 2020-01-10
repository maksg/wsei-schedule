//
//  URLImage.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 20/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct URLImage: View {
    var url: URL? {
        set {
            imageDownloader.url = newValue
        }
        get {
            return imageDownloader.url
        }
    }
    var placeholder: UIImage?
    
    @ObservedObject private var imageDownloader: URLImageDownloader
    
    init(url: URL?, placeholder: UIImage?, customCacheRequest: URLRequest? = nil) {
        self.imageDownloader = URLImageDownloader(url: url, customCacheRequest: customCacheRequest)
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if imageDownloader.image == nil {
                Image(uiImage: placeholder ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(uiImage: imageDownloader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(url: URL(string: "")!, placeholder: UIImage(named: "logo"))
    }
}
