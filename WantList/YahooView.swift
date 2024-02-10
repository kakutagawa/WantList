//
//  RakutenView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/06.
//

import SwiftUI

struct YahooView: View {
    @StateObject private var yahooDataList = GetYahooItem()
    @State private var inputText = ""

    var body: some View {
        VStack {
            TextField(
                "キーワード", text: $inputText,
                prompt: Text("キーワードを入力してください")
            )
            .onSubmit {
                yahooDataList.searchYahoo(keyword: inputText)
            }
            .submitLabel(.search)
            .padding()
        }

        List(yahooDataList.yahooGoods, id: \.self) { goods in
            Button {
                yahooDataList.yahooLink = goods.url
            } label: {
                Text(goods.name ?? "なし")
            }
        }
    }
}

#Preview {
    YahooView()
}
