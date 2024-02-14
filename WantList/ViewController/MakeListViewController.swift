//
//  MakeListViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/13.
//

import UIKit
import SwiftUI

final class MakeListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let makeListView = MakeListView()
        makeListView.addButtonDidTap.delegate = self

        let makeListViewController = UIHostingController(rootView: MakeListView())
        addChild(makeListViewController)
        makeListViewController.view.frame = view.bounds
        view.addSubview(makeListViewController.view)
        makeListViewController.didMove(toParent: self)

        makeListViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            makeListViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            makeListViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            makeListViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            makeListViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension MakeListViewController: MakeListDelegate {
    func transition(item: WantItem) {
        let listViewController = ListViewController()
        navigationController?.pushViewController(listViewController, animated: true)
    }
}
