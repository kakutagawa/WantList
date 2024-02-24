//
//  SearchViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/23.
//

import UIKit
import SwiftUI

final class SearchViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchViewController = UIHostingController(rootView: RakutenView())
        addChild(searchViewController)
        view.addSubview(searchViewController.view)
        searchViewController.didMove(toParent: self)

        searchViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            searchViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
