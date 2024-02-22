//
//  ListDetailView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI
import UIKit

struct ListDetailView: View {
    var listDetail: WantItem
    @State private var selectedItemTitle: String = ""
    @State private var selectedItemCaption: String = ""
    @State private var selectedItemPrice: String = ""
    @EnvironmentObject var items: ItemList

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("タイトル")){
                TextField("", text: $selectedItemTitle)
                    .onAppear() {
                        self.selectedItemTitle = listDetail.itemtitle ?? "なし"
                    }
            }
            Section(header: Text("メモ")){
                TextEditor(text: $selectedItemCaption)
                    .onAppear() {
                        self.selectedItemCaption = listDetail.itemCaption ?? "なし"
                    }
            }
            Section(header: Text("値段")){
                TextField("", text: $selectedItemPrice)
                    .keyboardType(.numberPad)
                    .onAppear() {
                        self.selectedItemPrice = listDetail.itemPrice ?? "なし"
                    }
            }
            Button {
                saveChange()
            } label: {
                Text("保存")
            }
        }
    }
    private func saveChange() {
        let changedItem = WantItem(id: listDetail.id, itemtitle: selectedItemTitle, itemCaption: selectedItemCaption, itemPrice: selectedItemPrice)
        let savedItem = items.itemList.map { item in
            var item = item
            if item.id == changedItem.id {
                item = changedItem
            }
            return item
        }
        items.itemList = savedItem
        presentationMode.wrappedValue.dismiss()
    }
}


//#Preview {
//    ListDetailView()
//}
