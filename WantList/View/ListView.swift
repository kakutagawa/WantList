//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

struct ListView: View {
    @State var wantList: [WantItem] = []
    private let itemListKey = "itemListKey"

    var body: some View {
        List(wantList, id: \.id) { item in
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
                    wantList = try decoder.decode([WantItem].self, from: savedItemList)
                } catch {
                    print("Failed to decode TodoItems: \(error)")
                }
            }
        }
        .onDisappear {
            do {
                let encoder = JSONEncoder()
                let encodedItemList = try encoder.encode(wantList)
                UserDefaults.standard.set(encodedItemList, forKey: itemListKey)
            } catch {
                print("Failed to encode ToDoItems: \(error)")
            }
        }
    }
}

#Preview {
    ListView()
}
