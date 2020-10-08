//
//  PullToRefreshView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 07/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct PullToRefreshView: UIViewRepresentable {

    let onRefresh: () -> Void
    @Binding var isRefreshing: Bool

    class Coordinator {
        let onRefresh: () -> Void
        let isRefreshing: Binding<Bool>

        init(onRefresh: @escaping () -> Void, isRefreshing: Binding<Bool>) {
            self.onRefresh = onRefresh
            self.isRefreshing = isRefreshing
        }

        @objc func onValueChanged() {
            isRefreshing.wrappedValue = true
            onRefresh()
        }
    }

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    private func tableView(root: UIView) -> UITableView? {
        for subview in root.subviews {
            if let tableView = subview as? UITableView {
                return tableView
            } else if let tableView = tableView(root: subview) {
                return tableView
            }
        }
        return nil
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let viewHost = uiView.superview?.superview,
              let tableView = self.tableView(root: viewHost)
        else { return }

        if tableView.refreshControl == nil {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
        }

        let refreshControl = tableView.refreshControl!
        if isRefreshing {
            refreshControl.beginRefreshingManually()
        } else {
            refreshControl.endRefreshingManually()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onRefresh: onRefresh, isRefreshing: $isRefreshing)
    }
}


extension UIRefreshControl {

    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: false)
        }
        beginRefreshing()
    }

    func endRefreshingManually() {
        endRefreshing()
        if let scrollView = superview as? UIScrollView {
            let y = frame.maxY + scrollView.adjustedContentInset.top
            scrollView.setContentOffset(CGPoint(x: 0, y: -y), animated: true)
        }
    }

}
