//
//  SafariView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/25.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    init(
        url: URL,
        configuration: SFSafariViewController.Configuration = .init(),
        controllerConfiguration: @escaping (SFSafariViewController) -> Void = { _ in }) {
            self.url = url
            self.configuration = configuration
            self.controllerConfiguration = controllerConfiguration
        }

    private let url: URL
    private let configuration: SFSafariViewController.Configuration
    private let controllerConfiguration: (SFSafariViewController) -> Void

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url, configuration: configuration)
        controllerConfiguration(controller)
        return controller
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: Context) {}
}
