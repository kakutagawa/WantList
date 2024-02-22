//
//  ListDetailViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/18.
//

import UIKit
import SwiftUI

final class ListDetailViewController: UIViewController {
    private var selectedItem: WantItem

    init(selectedItem: WantItem) {
        self.selectedItem = selectedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let listDetailViewController = UIHostingController(
            rootView: ListDetailView(listDetail: selectedItem)
        )
        addChild(listDetailViewController)
        view.addSubview(listDetailViewController.view)
        listDetailViewController.didMove(toParent: self)

        listDetailViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            listDetailViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            listDetailViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            listDetailViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listDetailViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
