//
//  TabBarView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 09/01/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct TabBarView<SelectionValue, Content> : UIViewControllerRepresentable where SelectionValue : Hashable {
    let selection: Binding<SelectionValue>?
    let viewControllers: [UIViewController]
    
    init<A: View>(selection: Binding<SelectionValue>? = nil, content: () -> TupleView<A>) {
        self.selection = selection
        let views = content().value
        self.viewControllers = [UIHostingController(tabBarView: views)]
    }
    
    init<A: View, B: View>(selection: Binding<SelectionValue>? = nil, content: () -> TupleView<(A, B)>) {
        self.selection = selection
        let views = content().value
        self.viewControllers = [UIHostingController(tabBarView: views.0),
                                UIHostingController(tabBarView: views.1)]
    }
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) { }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView<Int, Any>(selection: .constant(0)) {
            TupleView((
                Color.black
            ))
        }
    }
}
