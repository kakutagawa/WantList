//
//  SearchView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var getRakutenItem = GetRakutenItem()
    @StateObject private var getYahooItem = GetYahooItem()
    
    @State private var searchedResultList: [WantItem] = []
    @State private var inputText = ""
    @State private var isSafariView: Bool = false

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        VStack {
            TextField(
                "キーワード", text: $inputText,
                prompt: Text("キーワードを入力してください")
            )
            .onSubmit {
                getRakutenItem.searchRakuten(keyword: inputText)
                getYahooItem.searchYahoo(keyword: inputText)
            }
            .submitLabel(.search)
            .padding()
        }

        ScrollView {
            ForEach(getRakutenItem.rakutenGoods + getYahooItem.yahooGoods, id: \.id) { goods in
                VStack {
                    HStack {
                        AsyncImage(url: goods.itemImageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        VStack {
                            Text(goods.itemTitle ?? "なし")
                                .font(.headline)
                                .foregroundStyle(Color.black)
                            Text("¥\(goods.itemPrice?.description ?? "なし")")
                                .font(.title)
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    HStack {
                        Button { //ほしい物リストに追加するボタン
                            items.itemList.append(goods)
                        } label: {
                            Image(systemName: "arrow.down.circle.fill")
                        }
                        Button { //Safariを開くボタン
                            isSafariView = true
                        } label: {
                            Image(systemName: "safari.fill")
                        }
                    }
                }
                .fullScreenCover(isPresented: $isSafariView) {
                    if let safariUrl = goods.itemUrl {
                        SafariView(url: safariUrl) { configuration in
                            configuration.dismissButtonStyle = .close
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
