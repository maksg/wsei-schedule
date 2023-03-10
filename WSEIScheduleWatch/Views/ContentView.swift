//
//  ContentView.swift
//  WSEIScheduleWatch
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase: ScenePhase

    // MARK: - Views
    
    var body: some View {
        List {
            if viewModel.lectureDays.isEmpty {
                Text(Translation.Watch.noLectures.localized)
            } else {
                ForEach(viewModel.lectureDays) { lectureDay in
                    Section(header: DayHeader(date: lectureDay.date)) {
                        ForEach(lectureDay.lectures, content: LectureRow.init)
                    }
                }
            }
        }
        .onChange(of: scenePhase, perform: onScenePhaseChange)
    }

    // MARK: - Methods

    private func onScenePhaseChange(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            viewModel.reloadLectures()
        default:
            break
        }
    }
    
}

// MARK: -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
