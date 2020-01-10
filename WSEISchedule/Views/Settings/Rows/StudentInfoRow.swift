//
//  StudentInfoRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct StudentInfoRow: View {
    var viewModel: StudentInfoRowViewModel
    
    var body: some View {
        HStack {
            URLImage(url: viewModel.photoUrl, placeholder: .placeholder, customCacheRequest: viewModel.cacheRequest)
                .cornerRadius(6)
            VStack {
                Text(viewModel.name)
                    .font(.headline)
                Text(viewModel.number)
                    .font(.subheadline)
                Text(viewModel.courseName)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
    }
}

struct StudentInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StudentInfoRow(viewModel: .init(name: "John Appleseed", number: "12345", courseName: "WSEI Programming", photoUrl: nil))
            .previewLayout(.fixed(width: 300, height: 80))
    }
}
