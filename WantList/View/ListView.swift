//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var items: ItemList

    var body: some View {
        List(items.itemList) { item in
            HStack {
                Text(item.itemtitle ?? "なし")
                Spacer()
                Text("¥\(item.itemPrice ?? "なし")")
            }
        }
    }
}

//#Preview {
//    ListView()
//}
