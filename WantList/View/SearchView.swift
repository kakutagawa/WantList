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
    @State private var tappedAddButtonSet: Set<String> = Set()
    @State private var tappedRakuten: Bool = true
    @State private var tappedYahoo: Bool = true
    @State private var selectedGoods: WantItem?
    @State private var isShowAlert: Bool = false
    @State private var isSafariView: Bool = false
    @State private var currentPage = 1

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                    .onSubmit {
                        searchItem()
                    }
            }
            .submitLabel(.search)
            .padding()
            .background(Color(.systemGray6))
            .padding([.top, .trailing, .leading], 10)

            HStack {
                Button {
                    tappedRakuten.toggle()
                    searchItem()
                } label: {
                    Capsule()
                        .fill(tappedRakuten ? Color.pink : Color.clear)
                        .frame(width: 100, height: 40)
                        .overlay(
                            Capsule()
                                .stroke(Color.pink, lineWidth: 2)
                                .frame(width: 100, height: 40)
                        )
                        .overlay(
                            Text("Rakuten")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                        )
                }
                Button {
                    tappedYahoo.toggle()
                    searchItem()
                } label: {
                    Capsule()
                        .fill(tappedYahoo ? Color.pink : Color.clear)
                        .frame(width: 100, height: 40)
                        .overlay(
                            Capsule()
                                .stroke(Color.pink, lineWidth: 2)
                                .frame(width: 100, height: 40)
                        )
                        .overlay(
                            Text("Yahoo")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                        )
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
                                Text("\(goods.source.rawValue)")
                                    .foregroundStyle(Color.red)
                                    .font(.title3.bold())
                                Spacer()
                                Text("¥\(goods.itemPrice?.description ?? "なし")")
                                    .foregroundStyle(Color.pink)
                                    .font(.title3.bold())
                                Spacer()
                                Button { //ほしい物リストに追加するボタン
                                    isShowAlert = true
                                    self.selectedGoods = goods
                                } label: {
                                    Image(systemName: tappedAddButtonSet.contains(goods.id) ? "checkmark.circle.fill" : "arrow.down.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(tappedAddButtonSet.contains(goods.id) ? Color.green : Color.blue)
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button { //Safariを開くボタン
                                    isSafariView = true
                                } label: {
                                    Image(systemName:"safari.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color.blue)
                                }
                                .buttonStyle(PlainButtonStyle())

                            }
                            .alert("欲しい物リストに追加しますか？", isPresented: $isShowAlert) {
                                Button("追加する") {
                                    if let selectedGoods = selectedGoods {
                                        items.itemList.append(selectedGoods)
                                        tappedAddButtonSet.insert(selectedGoods.id)
                                    }
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
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    // スクロールが一定の位置に達したら次のページを取得
                    if isNearBottomEdge(contentOffset: geometry.frame(in: .global).maxY, bounds: geometry.size.height) {
                        currentPage += 1
                        loadNextPage()
                    }
                }
        }
    }
    private func searchItem() {
        getRakutenItem.rakutenGoods = []
        getYahooItem.yahooGoods = []
        if tappedRakuten == true && tappedYahoo == true {  //両方叩く
            getRakutenItem.searchRakuten(keyword: inputText)
            getYahooItem.searchYahoo(keyword: inputText)
        } else if tappedRakuten == true && tappedYahoo == false {  //Rakutenのみ叩く
            getRakutenItem.searchRakuten(keyword: inputText)
        } else if tappedRakuten == false && tappedYahoo == true {  //Yahooのみ叩く
            getYahooItem.searchYahoo(keyword: inputText)
        } else {  //どちらも叩かない
            return
        }
    }

    private func isNearBottomEdge(contentOffset: CGFloat, bounds: CGFloat) -> Bool {
        return contentOffset > bounds * 0.8 // 画面下部の80%に達したら true を返す
    }

    private func loadNextPage() {
        // ページネーションのための処理を実装
        // 例: APIリクエストを使って次のページのデータを取得する
    }

}

#Preview {
    SearchView()
}
