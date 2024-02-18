//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

protocol MakeListDelegate {
    func MakeListViewTransition()
}

protocol EditListDelegate {
    func ListDetailViewTransition(item: WantItem)
}

struct ListView: View {
    @EnvironmentObject var items: ItemList
    var makeListDelegate: MakeListDelegate?
    var editListDelegate: EditListDelegate?

    var body: some View {
        VStack {
            List(items.itemList) { item in
                Button {
                    editListDelegate?.ListDetailViewTransition(item: item)
                } label: {
                    HStack {
                        Text(item.itemtitle ?? "なし")
                        Spacer()
                        Text("¥\(item.itemPrice ?? "なし")")
                    }
                }
            }
            Button {
                makeListDelegate?.MakeListViewTransition()
            } label: {
                Text("新規作成")
            }
        }
    }
}

#Preview {
    ListView()
}
