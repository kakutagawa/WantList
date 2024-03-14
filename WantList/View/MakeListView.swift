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
    @State private var itemUrl: String = ""
    @State private var itemImage: UIImage?
    @State var showingAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button {
                showingAlert = true
            } label: {
                if let image = itemImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.top, 10)
                } else {
                    Text("No Image")
                        .font(Font.system(size: 24).bold())
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 200)
                        .background(Color(UIColor.lightGray))
                        .padding(.top, 10)
                }
            }

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
                Section(header: Text("URL")){
                    TextField("ウェブサイトのURLを入力", text: $itemUrl)
                }
                Button {
                    addItemList()
                } label: {
                    Text("追加")
                }
            }
            .sheet(isPresented: $showingAlert) {
                
            } content: {
                ImagePicker(image: $itemImage)
            }
        }
    }

    private func addItemList() {
        let newItem = WantItem(id: "\(items.itemList.count + 1)", itemTitle: itemTitle, itemCaption: itemCaption, itemPrice: itemPrice, itemUrl: URL(string: itemUrl), itemImage: itemImage, source: .empty)
        items.itemList.append(newItem)
        itemTitle = ""
        itemCaption = ""
        itemPrice = ""
        itemUrl = ""
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    MakeListView()
}
