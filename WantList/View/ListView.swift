//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

struct ListView: View {
    @Binding var itemList: [WantItem]
    private let itemListKey = "itemListKey"

    var body: some View {
        List(itemList, id: \.id) { item in
            HStack {
                Text(item.itemtitle ?? "なし")
                Spacer()
                Text("¥\(item.itemPrice ?? "なし")")
            }
        }
        .onAppear {
            if let savedItemList = UserDefaults.standard.data(forKey: itemListKey) {
                do {
                    let decoder = JSONDecoder()
                    itemList = try decoder.decode([WantItem].self, from: savedItemList)
                } catch {
                    print("Failed to decode TodoItems: \(error)")
                }
            }
        }
        .onDisappear {
            do {
                let encoder = JSONEncoder()
                let encodedItemList = try encoder.encode(itemList)
                UserDefaults.standard.set(encodedItemList, forKey: itemListKey)
            } catch {
                print("Failed to encode ToDoItems: \(error)")
            }
        }
    }
}

//#Preview {
//    ListView(itemList: )
//}
