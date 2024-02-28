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
    @State private var selectedItemUrl: String = ""
    @State private var selectedItemImage: UIImage?
    @State private var showingAlert: Bool = false
    @State private var isSafariView: Bool = false
    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button {
                showingAlert = true
            } label: {  //以下、条件分岐が長すぎるため、enumやswitch文に後ほど変更を加える
                if let image = listDetail.itemImage {  //listDetailにUIImage型の画像データがあった場合
                    //画像の変更がされた場合、その新しい画像を表示
                    if let selectedItemImage = selectedItemImage {
                        Image(uiImage: selectedItemImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 10)
                    //画像の変更がされなかった場合、listDetailの画像を表示
                    } else {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 10)
                    }
                } else if let image = listDetail.itemImageUrl { //listDetailにURL型の画像データがあった場合
                    //画像の変更がされた場合、その新しい画像を表示
                    if let selectedItemImage = selectedItemImage {
                        Image(uiImage: selectedItemImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 10)
                        //画像の変更がされなかった場合、listDetailの画像を表示
                    } else {
                        AsyncImage(url: image) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                } else {  //もしlistDetailに画像データがなかった場合
                    //画像が追加された場合、その画像を表示
                    if let selectedItemImage = selectedItemImage {
                        Image(uiImage: selectedItemImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 10)
                    //画像が追加されない場合、「No Image」と表示
                    } else {
                        Text("No Image")
                            .font(Font.system(size: 24).bold())
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 200)
                            .background(Color(UIColor.lightGray))
                            .padding(.top, 10)
                    }
                }
            }
            Form {
                Section(header: Text("タイトル")){
                    TextField("", text: $selectedItemTitle)
                        .onAppear() {
                            self.selectedItemTitle = listDetail.itemTitle ?? "なし"
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
                Section(header: Text("URL")){
                    TextField("", text: $selectedItemUrl)
                        .onAppear() {
                            self.selectedItemUrl = listDetail.itemUrl?.absoluteString ?? "なし"
                        }
                }
                Button {
                    isSafariView = true
                } label: {
                    Text("ウェブサイトにジャンプ")
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
        //ここにSafariViewに飛ぶ処理を追加予定
    }
    private func saveChange() {
        let changedItem = WantItem(id: listDetail.id, itemTitle: selectedItemTitle, itemCaption: selectedItemCaption, itemPrice: selectedItemPrice, itemUrl: URL(string: selectedItemUrl), itemImage: selectedItemImage ?? listDetail.itemImage)
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
