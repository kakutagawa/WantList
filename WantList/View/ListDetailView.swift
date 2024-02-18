//
//  ListDetailView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI

struct ListDetailView: View {
    var listDetail: WantItem
    @State var selectedItemTitle: String
    @State var selectedItemCaption: String
    @State var selectedItemPrice: String

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
        }
    }
}

//#Preview {
//    ListDetailView()
//}
