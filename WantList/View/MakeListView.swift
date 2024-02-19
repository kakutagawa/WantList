//
//  MakeListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI

struct MakeListView: View {
    @EnvironmentObject var items: ItemList
    @State private var itemTitle: String = ""
    @State private var itemCaption: String = ""
    @State private var itemPrice: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("タイトル")){
                TextField("タイトルを入力", text: $itemTitle)
            }
            Section(header: Text("メモ")){
                TextEditor(text: $itemCaption)
                    .overlay(alignment: .topLeading) {
                        if itemCaption.isEmpty {
                            Text("メモを入力")
                                .allowsHitTesting(false)
                                .foregroundStyle(Color(uiColor: .placeholderText))
                        }
                    }
            }
            Section(header: Text("値段")){
                TextField("値段", text: $itemPrice)
                    .keyboardType(.numberPad)
            }
            Button {
                addItemList()
            } label: {
                Text("追加")
            }
        }
    }

    private func addItemList() {
        let newItem = WantItem(id: items.itemList.count + 1, itemtitle: itemTitle, itemCaption: itemCaption, itemPrice: itemPrice)
        items.itemList.append(newItem)
        itemTitle = ""
        itemCaption = ""
        itemPrice = ""
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    MakeListView()
}
