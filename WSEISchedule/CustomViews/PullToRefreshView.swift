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

    // MARK: - Coordinator

    class Coordinator {
        let parent: PullToRefreshView

        init(parent: PullToRefreshView) {
            self.parent = parent
        }

        @objc func onValueChanged() {
            Task {
                await parent.onRefresh()
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
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

}
