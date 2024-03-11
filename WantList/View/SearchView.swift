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
    @State private var isShowProgressView = false

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                    .onSubmit {
                        deleteResult()
                        currentPage = 1
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
                    deleteResult()
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
                    deleteResult()
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
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 1)) {
                Section {
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
                                        Button {
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

                                        Button {
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
                        .frame(maxHeight: 120)
                        Divider()
                            .fullScreenCover(isPresented: $isSafariView) {
                                if let safariUrl = goods.itemUrl {
                                    SafariView(url: safariUrl) { configuration in
                                        configuration.dismissButtonStyle = .close
                                    }
                                    .edgesIgnoringSafeArea(.all)
                                }
                            }
                            .onAppear {
                                if let lastRakutenItem = getRakutenItem.rakutenGoods.last,
                                   let lastYahooItem = getYahooItem.yahooGoods.last,
                                   goods.id == lastRakutenItem.id || goods.id == lastYahooItem.id {
                                    isShowProgressView = true
                                    currentPage += 1
                                    searchItem()
                                }
                            }
                    }
                    .padding(.horizontal, 10)
                }
            }

            if isShowProgressView {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 150)
                    .onAppear {
                        searchItem()
                    }
            }
        }

    }
    private func deleteResult() {
        getRakutenItem.rakutenGoods = []
        getYahooItem.yahooGoods = []
    }
    private func searchItem() {
        isShowProgressView = true
        if tappedRakuten == true && tappedYahoo == true {  //両方叩く
            getRakutenItem.searchRakuten(keyword: inputText, page: currentPage)
            getYahooItem.searchYahoo(keyword: inputText, page: currentPage)
        } else if tappedRakuten == true && tappedYahoo == false {  //Rakutenのみ叩く
            getRakutenItem.searchRakuten(keyword: inputText, page: currentPage)
        } else if tappedRakuten == false && tappedYahoo == true {  //Yahooのみ叩く
            getYahooItem.searchYahoo(keyword: inputText, page: currentPage)
        } else {  //どちらも叩かない
            return
        }
    }
}

#Preview {
    SearchView()
}
