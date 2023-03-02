//
//  PullToRefreshView.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 07/10/2020.
//  Copyright © 2020 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct PullToRefreshView: UIViewRepresentable {

    // MARK: - Properties

    let onRefresh: () async -> Void
    @Binding var isRefreshing: Bool
    @State var firstRefresh: Bool = true

    private var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    // MARK: - Coordinator

    class Coordinator {
        let parent: PullToRefreshView

        init(parent: PullToRefreshView) {
            self.parent = parent
        }

        @objc func onValueChanged() {
            parent.isRefreshing = true
            Task {
                await parent.onRefresh()
                parent.isRefreshing = false
            }
        }
    }

    // MARK: - Methods

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
            guard !refreshControl.isRefreshing else { return }
            let y = tableView.contentOffset.y - refreshControl.frame.height
            tableView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
            refreshControl.beginRefreshing()
        } else {
            guard refreshControl.isRefreshing else { return }
            refreshControl.endRefreshing()
            if firstRefresh && tableView.contentOffset.y <= -tableView.adjustedContentInset.top && isPhone {
                let y = refreshControl.frame.maxY + tableView.adjustedContentInset.top
                tableView.setContentOffset(CGPoint(x: 0, y: -y*5), animated: true)
                firstRefresh = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

}
