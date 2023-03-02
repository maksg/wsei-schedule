//
//  GradeRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 06/10/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct GradeRow: View {

    // MARK: - Properties

    let grade: Grade

    // MARK: - Views

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.subject)
                    .font(.headline)
                    .accessibility(hint: Text(Translation.Accessibility.Grades.subject.localized))

                HStack(alignment: .top) {
                    Image.code
                        .foregroundColor(.main)
                        .accessibilityElement()
                        .accessibility(label: Text(Translation.Accessibility.Grades.lectureForm.localized))
                    Text(grade.lectureForm)
                }

                HStack(alignment: .top) {
                    Image.lecturer
                        .foregroundColor(.orange)
                        .accessibilityElement()
                        .accessibility(label: Text(Translation.Accessibility.Grades.lecturer.localized))
                    Text(grade.lecturer)
                }
            }
            .font(.footnote)

            Spacer()

            VStack(spacing: 8) {
                Text(grade.value)
                    .font(.headline)
                    .foregroundColor(.main)
                    .accessibility(hint: Text(Translation.Accessibility.Grades.grade.localized))
                
                if !grade.ects.isEmpty {
                    Text("ECTS: \(grade.ects)")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .accessibility(hint: Text(Translation.Accessibility.Grades.ects.localized))
                }
            }
            .frame(width: 60)
        }
    }
}

// MARK: -

struct GradeRow_Previews: PreviewProvider {
    static var previews: some View {
        GradeRow(grade: MockData.grade)
    }
}
