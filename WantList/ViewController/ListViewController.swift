//
//  ListViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/13.
//

import UIKit
import SwiftUI

final class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var listView = ListView()
        listView.makeListDelegate = self
        listView.editListDelegate = self

        let listViewController = UIHostingController(rootView: listView)
        addChild(listViewController)
        listViewController.view.frame = view.bounds
        view.addSubview(listViewController.view)
        listViewController.didMove(toParent: self)

        listViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            listViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            listViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            listViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ListViewController: MakeListDelegate {
    func MakeListViewTransition() {
        let makeListViewController = MakeListViewController()
        navigationController?.pushViewController(makeListViewController, animated: true)
    }
}

extension ListViewController: EditListDelegate {
    func ListDetailViewTransition(item: WantItem) {
        let listDetailViewController = ListDetailViewController(selectedItem: item)
        navigationController?.pushViewController(listDetailViewController, animated: true)
    }
}


//UIViewControllerRepresentableを使う
struct UIKitListViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        //UINavigationControllerでMakeListViewをラップ
        UINavigationController(rootViewController: ListViewController())
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}
