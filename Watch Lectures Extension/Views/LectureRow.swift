//
//  LectureRow.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct LectureRow: View {

    // MARK: - Properties

    var lecture: Lecture
    @State private var showDetails: Bool = false

    @State private var expandedHeight: CGFloat = .zero
    @State private var defaultHeight: CGFloat = .zero

    private let verticalPadding: CGFloat = 4.0

    private var rowHeight: CGFloat {
        if showDetails {
            return expandedHeight
        } else {
            return defaultHeight + verticalPadding * 2
        }
    }

    // MARK: - Views
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 3) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(lecture.subject)
                        .font(.headline)
                        .lineLimit(nil)

                    HStack(alignment: .top) {
                        Image.time.foregroundColor(.red)
                        HStack(spacing: 0) {
                            Text(lecture.fromDate.shortHour)
                            Text("-")
                            Text(lecture.toDate.shortHour)
                        }
                    }

                    HStack(alignment: .top) {
                        Image.classroom.foregroundColor(.blue)
                        Text(lecture.classroom)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .heightReader(height: $defaultHeight)
                
                HStack(alignment: .top) {
                    Image.code.foregroundColor(.main)
                    Text(lecture.code)
                }
                HStack(alignment: .top) {
                    Image.lecturer.foregroundColor(.orange)
                    Text(lecture.lecturer)
                }
                HStack(alignment: .top) {
                    Image.comments.foregroundColor(.indigo)
                    Text(lecture.comments)
                }
            }
            .font(.footnote)
            .padding(.horizontal, 0)
            .padding(.vertical, verticalPadding)
        }
        .fixedSize(horizontal: false, vertical: true)
        .heightReader(height: $expandedHeight)
        .animatableRowHeight(rowHeight)
    }

    // MARK: - Methods

    private func onTap() {
        withAnimation(.easeInOut(duration: 0.1)) {
            showDetails.toggle()
        }
    }
    
}

struct LectureRow_Previews: PreviewProvider {
    static var previews: some View {
        LectureRow(lecture: MockData.lecture)
    }
}
