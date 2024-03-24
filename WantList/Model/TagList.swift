//
//  TagList.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/03/24.
//

import Foundation

final class TagList: ObservableObject {
    @Published var tagList: [ItemTag] {
        didSet {
            if let encoded = try? JSONEncoder().encode(tagList) {
                UserDefaults.standard.set(encoded, forKey: "tagList")
            }
        }
    }
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "tagList") {
            if let loadedData = try? JSONDecoder().decode([ItemTag].self, from: savedData) {
                tagList = loadedData
                return
            }
        }
        tagList = []
    }
}
