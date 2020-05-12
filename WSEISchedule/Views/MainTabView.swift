//
//  MainTabView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/06/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainTabViewModel
    @State private var isSignInViewPresented: Bool = false
    
    var body: some View {
        TabBarView<Tab, Any>(selection: $viewModel.selectedTab) {
            TupleView((
                ScheduleView(viewModel: viewModel.scheduleViewModel),
                SettingsView(viewModel: viewModel.settingsViewModel)
            ))
        }
        .accentColor(.primary)
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: onAppear)
        .sheet(isPresented: $isSignInViewPresented) {
            SignInView(viewModel: SignInViewModel(), onDismiss: self.viewModel.reloadLectures)
                .environmentObject(KeyboardObserver())
        }
    }
    
    private func onAppear() {
        guard !viewModel.isSignedIn else { return }
        isSignInViewPresented = true
    }
}

struct MainTabView_Previews : PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: MainTabViewModel())
    }
}
