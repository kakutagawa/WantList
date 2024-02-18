//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

protocol ListDelegate {
    func transition()
}

struct ListView: View {
    @EnvironmentObject var items: ItemList
    var delegate: ListDelegate?

    var body: some View {
        VStack {
            List(items.itemList) { item in
                HStack {
                    Text(item.itemtitle ?? "なし")
                    Spacer()
                    Text("¥\(item.itemPrice ?? "なし")")
                }
            }
            Button {
                delegate?.transition()
            } label: {
                Text("新規作成")
            }
        }
    }
}

#Preview {
    ListView()
}
