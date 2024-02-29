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
    @State private var isSafariView: Bool = false

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
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
                                .foregroundStyle(Color.black)
                            HStack {
                                Text("¥\(goods.itemPrice?.description ?? "なし")")
                                    .foregroundStyle(Color.pink)
                                    .font(.title3.bold())
                                Spacer()
                                //                        Text(goods.条件分岐（RakutenかYahooか） ? "R" : "Y")
                                //                            .font(.title)
                                //                            .foregroundStyle(Color.red)
                                Button { //ほしい物リストに追加するボタン
                                    items.itemList.append(goods)
                                    tappedAddButtonSet.insert(goods.id)
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
