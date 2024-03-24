//
//  TagViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/03/20.
//

import UIKit
import SwiftUI

final class TagViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "タグ一覧"

        var tagView = TagView()
        tagView.tagViewDelegate = self

        let tagViewController = UIHostingController(rootView: tagView)
        addChild(tagViewController)
        view.addSubview(tagViewController.view)
        tagViewController.didMove(toParent: self)

        tagViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tagViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            tagViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            tagViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension TagViewController: TagViewDelegate {
    func transitionMakeTagView() {
        let makeTagViewController = MakeTagViewController()
        navigationController?.pushViewController(makeTagViewController, animated: true)
    }
}
