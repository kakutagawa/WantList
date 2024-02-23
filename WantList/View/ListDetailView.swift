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
    @State private var selectedItemImage: UIImage?
    @State var showingAlert: Bool = false
    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if let image = selectedItemImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.top, 10)
                    .onAppear() {
                        self.selectedItemImage = listDetail.itemImage
                    }
            } else {
                Text("No Image")
                    .font(Font.system(size: 24).bold())
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 200)
                    .background(Color(UIColor.lightGray))
                    .padding(.top, 10)
            }

            Button {
                showingAlert = true
            } label: {
                Text("Select Image")
                    .font(Font.system(size:20).bold())
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 16)
                    .background(Color(UIColor.lightGray))
            }
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
            .sheet(isPresented: $showingAlert) {

            } content: {
                ImagePicker(image: $selectedItemImage)
            }
        }
    }
    private func saveChange() {
        let changedItem = WantItem(id: listDetail.id, itemtitle: selectedItemTitle, itemCaption: selectedItemCaption, itemPrice: selectedItemPrice, itemImage: selectedItemImage)
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
