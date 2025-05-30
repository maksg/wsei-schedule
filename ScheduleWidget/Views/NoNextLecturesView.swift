//
//  NoNextLecturesView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 13/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct NoNextLecturesView: View {

    // MARK: - Views

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text("🏖")
                .font(.largeTitle)
            Text(.widget(.noNextLectures))
            Spacer()
        }
    }
    
}

struct NoNextLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        NoNextLecturesView()
    }
}
