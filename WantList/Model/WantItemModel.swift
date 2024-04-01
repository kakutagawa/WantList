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

enum TagColor: String, Codable, CaseIterable, ShapeStyle {
    case clear
    case red
    case blue
    case green
    case yellow
    case orange
    case purple
    case pink
    case teal
    case cyan
    case gray

    var color: Color {
        switch self {
        case .clear: return .clear
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .teal: return .teal
        case .cyan: return .cyan
        case .gray: return .gray
        }
    }
}

struct ItemTag: Codable, Hashable {
    var tagTitle: String?
    var tagColor: TagColor
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
    var itemTag: ItemTag

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
        source: ItemSource,
        itemTag: ItemTag
    ) {
        self.id = id
        self.itemTitle = itemTitle
        self.itemCaption = itemCaption
        self.itemPrice = itemPrice
        self.itemUrl = itemUrl
        self.itemShopName = itemShopName
        self.itemImageUrl = itemImageUrl
        self.source = source
        self.itemTag = itemTag

        if let itemImage = itemImage {
            self.itemImageData = itemImage.pngData()
        }
    }
}
