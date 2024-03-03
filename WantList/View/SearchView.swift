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

    @State private var inputText = ""
    @State private var tappedAddButtonSet: Set<Int> = Set()
    @State private var isShowAlert: Bool = false
    @State private var isSafariView: Bool = false

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                    .onSubmit {
                        getRakutenItem.searchRakuten(keyword: inputText)
                        getYahooItem.searchYahoo(keyword: inputText)
                    }
            }
            .submitLabel(.search)
            .padding()
            .background(Color(.systemGray6))
            .padding()

            HStack {
                Button {

                } label: {
                    Text("Rakuten")
                }
                Button {

                } label: {
                    Text("Yahoo")
                }
            }
        }

        List {
            ForEach(getRakutenItem.rakutenGoods + getYahooItem.yahooGoods, id: \.id) { goods in
                VStack {
                    HStack {
                        AsyncImage(url: goods.itemImageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        VStack(alignment: .leading) {
                            Text(goods.itemTitle ?? "なし")
                                .font(.headline)
                                .foregroundStyle(Color("TextColor"))
                            HStack {
                                Text("¥\(goods.itemPrice?.description ?? "なし")")
                                    .foregroundStyle(Color.pink)
                                    .font(.title3.bold())
                                Spacer()
                                Button { //ほしい物リストに追加するボタン
                                    isShowAlert = true
                                    // すでに追加済みで、緑のチェックマークになっている場合
                                    // 何も処理を行わない、というコードを追加する必要あり
                                } label: {
                                    Image(systemName: tappedAddButtonSet.contains(goods.id) ? "checkmark.circle.fill" : "arrow.down.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(tappedAddButtonSet.contains(goods.id) ? Color.green : Color.blue)
                                }
                                Button { //Safariを開くボタン
                                    isSafariView = true
                                } label: {
                                    Image(systemName:"safari.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                }
                            }
                            .alert("欲しい物リストに追加しますか？", isPresented: $isShowAlert) {
                                Button("追加する") {
                                    print(goods)
                                    items.itemList.append(goods)
                                    tappedAddButtonSet.insert(goods.id)
                                }
                                Button("キャンセル", role: .cancel) {}
                            }
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
                .frame(maxHeight: 120)
            }
        }
    }
}

#Preview {
    SearchView()
}
