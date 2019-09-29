//
//  ContentView.swift
//  Watch Lectures Extension
//
//  Created by Maksymilian Galas on 19/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State var viewModel: ContentViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.lectureDays) { lectureDay in
                Section(header: DayHeader(date: lectureDay.date)) {
                    ForEach(lectureDay.lectures as? [CodableLecture] ?? [], id: \.self, content: LectureRow.init)
                }
            }
        }
        .onAppear {
            self.viewModel.reloadLectures()
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
#endif
