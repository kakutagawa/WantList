//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

protocol ListViewDelegate {
    func transitionListDetailView(item: WantItem)
    func transitionMakeListView()
}

struct ListView: View {
    @EnvironmentObject var items: ItemList
    var listViewDelegate: ListViewDelegate?

    var body: some View {
        VStack {
            List(items.itemList) { item in
                Button {
                    listViewDelegate?.transitionListDetailView(item: item)
                } label: {
                    HStack {
                        Text(item.itemtitle ?? "なし")
                        Spacer()
                        Text("¥\(item.itemPrice ?? "なし")")
                    }
                }
            }
            Button {
                listViewDelegate?.transitionMakeListView()
            } label: {
                Text("新規作成")
            }
        }
    }
}

#Preview {
    ListView()
}
