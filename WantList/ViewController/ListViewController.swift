//
//  ListViewController.swift
//  WantList
//
////  Created by 芥川浩平 on 2024/02/13.
////
//
//import UIKit
//import SwiftUI
//
//final class ListViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let listViewController = UIHostingController(rootView: ListView(itemList: [WantItem(itemtitle: "", itemCaption: "", itemPrice: "")]))
//        addChild(listViewController)
//        listViewController.view.frame = view.bounds
//        view.addSubview(listViewController.view)
//        listViewController.didMove(toParent: self)
//
//        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            listViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
//            listViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
//            listViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            listViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//}
