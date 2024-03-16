//
//  WantItemModel.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/14.
//

import SwiftUI

enum ItemSource: String, Codable {
    case empty = ""
    case rakuten = "R"
    case yahoo = "Y"
}

struct WantItem: Codable, Identifiable, Hashable {
    var id: String
    var itemTitle: String?
    var itemCaption: String?
    var itemPrice: String?
    var itemUrl: URL?
    var itemShopName: String?
    var itemImageUrl: URL?
    var itemImageData: Data?
    var source: ItemSource

    var itemImage: UIImage? {
        if let itemImageData = itemImageData {
            return UIImage(data: itemImageData)
        }
        return nil
    }

    init(
        id: String,
        itemTitle: String? = nil,
        itemCaption: String? = nil,
        itemPrice: String? = nil,
        itemUrl: URL? = nil,
        itemShopName: String? = nil,
        itemImageUrl: URL? = nil,
        itemImage: UIImage? = nil,
        source: ItemSource
    ) {
        self.id = id
        self.itemTitle = itemTitle
        self.itemCaption = itemCaption
        self.itemPrice = itemPrice
        self.itemUrl = itemUrl
        self.itemShopName = itemShopName
        self.itemImageUrl = itemImageUrl
        self.source = source

        if let itemImage = itemImage {
            self.itemImageData = itemImage.pngData()
        }
    }
}
