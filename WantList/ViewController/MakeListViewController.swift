//
//  MakeListViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/13.
//

import UIKit
import SwiftUI

final class MakeListViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var makeListView = MakeListView()
        makeListView.makeListViewDelegate = self

        let makeListViewController = UIHostingController(rootView: makeListView)
        addChild(makeListViewController)
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

extension MakeListViewController: MakeListViewDelegate {
    func transitionTagView() {
        let tagViewController = TagViewController()
        navigationController?.pushViewController(tagViewController, animated: true)
    }
}
