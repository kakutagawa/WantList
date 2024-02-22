//
//  WantItemList.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/19.
//

import Foundation

final class ItemList: ObservableObject {
    @Published var itemList: [WantItem] {
        didSet {
            if let encoded = try? JSONEncoder().encode(itemList) {
                UserDefaults.standard.set(encoded, forKey: "itemList")
            }
        }
    }

    init() {
        if let savedData = UserDefaults.standard.data(forKey: "itemList") {
            if let loadedData = try? JSONDecoder().decode([WantItem].self, from: savedData) {
                itemList = loadedData
                return
            }
        }
        itemList = []
    }
}
