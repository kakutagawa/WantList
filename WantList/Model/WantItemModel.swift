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

    init(id: Int, itemtitle: String? = nil, itemCaption: String? = nil, itemPrice: String? = nil) {
        self.id = id
        self.itemtitle = itemtitle
        self.itemCaption = itemCaption
        self.itemPrice = itemPrice
    }
}
