//
//  GradeRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct GradeRow: View {

    // MARK: Properties

    let grade: Grade

    // MARK: Views

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(grade.subject)
                    .font(.headline)
                Text(grade.lecturer)
                    .font(.footnote)
            }

            Spacer()

            Text(grade.value)
                .font(.headline)
                .foregroundColor(.main)
        }
    }
}

struct GradeRow_Previews: PreviewProvider {
    static var previews: some View {
        GradeRow(grade: MockData.grade)
    }
}
