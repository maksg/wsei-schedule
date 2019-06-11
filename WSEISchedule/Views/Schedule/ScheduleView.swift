//
//  ScheduleView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct ScheduleView : View {
    var viewModel: ScheduleViewModel
    
    var body: some View {
        NavigationView {
            Text(viewModel.title)
                .navigationBarTitle(Text(viewModel.title))
        }
    }
}

#if DEBUG
struct ScheduleView_Previews : PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: .init())
    }
}
#endif
