//
//  StudentInfoRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/12/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct StudentInfoRow: View {

    // MARK: - Properties

    var viewModel: StudentInfoRowViewModel

    // MARK: - Views
    
    var body: some View {
        HStack {
            URLImage(url: viewModel.photoUrl, placeholder: .placeholder, customCacheRequest: viewModel.cacheRequest)
                .cornerRadius(6)
                .accessibilityHint(Text(.accessibility(.settingsProfilePhoto)))
            VStack {
                Text(viewModel.name)
                    .font(.headline)
                    .accessibilityHint(Text(.accessibility(.settingsName)))
                Text(viewModel.number)
                    .font(.subheadline)
                    .accessibilityHint(Text(.accessibility(.settingsIndexNumber)))
                Text(viewModel.courseName)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .accessibilityHint(Text(.accessibility(.settingsCourseName)))
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
    }

}

// MARK: -

struct StudentInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StudentInfoRow(viewModel: StudentInfoRowViewModel(name: "John Appleseed", number: "12345", courseName: "WSEI Programming", photoUrl: nil))
            .previewLayout(.fixed(width: 300, height: 80))
    }
}
