//
//  RakutenView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/06.
//

import SwiftUI

struct RakutenView: View {
    @StateObject private var rakutenDataList = GetRakutenItem()
    @State private var inputText = ""

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField(
                "キーワード", text: $inputText,
                prompt: Text("キーワードを入力してください")
            )
            .onSubmit {
                rakutenDataList.searchRakuten(keyword: inputText)
            }
            .submitLabel(.search)
            .padding()
        }

        ScrollView {
            ForEach(rakutenDataList.rakutenGoods, id: \.self) { goods in
                VStack {
                    HStack {
                        AsyncImage(url: goods.mediumImageUrls?.first?.imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        VStack {
                            Text(goods.itemName ?? "なし")
                                .font(.headline)
                                .foregroundStyle(Color.black)
                            Text("¥\(goods.itemPrice?.description ?? "なし")")
                                .font(.title)
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    HStack {
                        Button {
                            guard let imageUrl = goods.mediumImageUrls?.first?.imageUrl else { return }
                            let url = URL(string: imageUrl.absoluteString)!
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                if let error = error {
                                    print("Error loading image data: \(error)")
                                    return
                                }
                                if let data = data, let image = UIImage(data: data) {
                                    // メインスレッド
                                    DispatchQueue.main.async {
                                        let newItem = WantItem(id: items.itemList.count + 1, itemtitle: goods.itemName, itemCaption: "", itemPrice: goods.itemPrice?.description, itemImage: image)
                                        // ほしい物リストに入れる
                                        items.itemList.append(newItem)
                                    }
                                }
                            }.resume()
                        } label: {
                            Image(systemName: "arrow.down.circle.fill")
                        }
                        Button {
                            //Safariで商品情報ページを表示する
                        } label: {
                            Image(systemName: "safari.fill")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RakutenView()
}
