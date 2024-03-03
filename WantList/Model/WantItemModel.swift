//
//  WantItemModel.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/14.
//

import SwiftUI

struct WantItem: Codable, Identifiable, Hashable {
    var id: Int
    var itemTitle: String?
    var itemCaption: String?
    var itemPrice: String?
    var itemUrl: URL?
    var itemImageUrl: URL?
    var itemImageData: Data?

    var itemImage: UIImage? {
        if let itemImageData = itemImageData {
            return UIImage(data: itemImageData)
        }
        return nil
    }

    init(id: Int, itemTitle: String? = nil, itemCaption: String? = nil, itemPrice: String? = nil, itemUrl: URL? = nil, itemImageUrl: URL? = nil, itemImage: UIImage? = nil) {
        self.id = id
        self.itemTitle = itemTitle
        self.itemCaption = itemCaption
        self.itemPrice = itemPrice
        self.itemUrl = itemUrl
        self.itemImageUrl = itemImageUrl

        if let itemImage = itemImage {
            self.itemImageData = itemImage.pngData()
        }
    }
}
