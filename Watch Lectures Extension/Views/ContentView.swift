//
//  ContentView.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ContentViewModel

    // MARK: - Views
    
    var body: some View {
        List {
            if viewModel.lectureDays.isEmpty {
                Text(Translation.Watch.noLectures.localized)
            } else {
                ForEach(viewModel.lectureDays) { lectureDay in
                    Section(header: DayHeader(date: lectureDay.date)) {
                        ForEach(lectureDay.lectures as? [CodableLecture] ?? [], id: \.self, content: LectureRow.init)
                    }
                }
            }
        }
        .onAppear(perform: onAppear)
    }

    // MARK: - Methods

    private func onAppear() {
        viewModel.reloadLectures()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
