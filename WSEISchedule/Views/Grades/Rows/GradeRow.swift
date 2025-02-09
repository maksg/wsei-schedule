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
                    .accessibilityHint(Text(Translation.Accessibility.Grades.subject.localized))

                HStack(alignment: .top) {
                    Image.code
                        .foregroundColor(.main)
                        .accessibilityElement()
                        .accessibilityLabel(Text(Translation.Accessibility.Grades.lectureForm.localized))
                    Text(grade.lectureForm)
                }

                if !grade.lecturer.isEmpty {
                    HStack(alignment: .top) {
                        Image.lecturer
                            .foregroundColor(.orange)
                            .accessibilityElement()
                            .accessibilityLabel(Text(Translation.Accessibility.Grades.lecturer.localized))
                        Text(grade.lecturer)
                    }
                }
            }
            .font(.footnote)

            Spacer()

            VStack(spacing: 8) {
                if !grade.value.isEmpty {
                    Text(grade.value)
                        .font(.headline)
                        .foregroundColor(grade.value == "2" ? .red : .main)
                        .accessibilityHint(Text(Translation.Accessibility.Grades.grade.localized))
                }
                
                if !grade.ects.isEmpty {
                    Text("ECTS: \(grade.ects)")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .accessibilityHint(Text(Translation.Accessibility.Grades.ects.localized))
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
