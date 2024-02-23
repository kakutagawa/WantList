//
//  WantItemModel.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/14.
//

import SwiftUI

struct WantItem: Codable, Identifiable {
    var id: Int
    var itemtitle: String?
    var itemCaption: String?
    var itemPrice: String?
    var itemImageData: Data?

    var itemImage: UIImage? {
        if let itemImageData = itemImageData {
            return UIImage(data: itemImageData)
        }
        return nil
    }

    init(id: Int, itemtitle: String? = nil, itemCaption: String? = nil, itemPrice: String? = nil, itemImage: UIImage? = nil) {
        self.id = id
        self.itemtitle = itemtitle
        self.itemCaption = itemCaption
        self.itemPrice = itemPrice
        
        if let itemImage = itemImage {
            self.itemImageData = itemImage.pngData()
        }
    }
}
