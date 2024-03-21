//
//  MakeTagViewController.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/03/20.
//

import UIKit
import SwiftUI

final class MakeTagViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let makeTagViewController = UIHostingController(rootView: MakeTagView())
        addChild(makeTagViewController)
        view.addSubview(makeTagViewController.view)
        makeTagViewController.didMove(toParent: self)

        makeTagViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            makeTagViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            makeTagViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            makeTagViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            makeTagViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
