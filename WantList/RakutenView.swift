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

        List(rakutenDataList.rakutenGoods, id: \.self) { goods in
            Button {
                rakutenDataList.rakutenLink = goods.itemUrl
            } label: {
                VStack {
                    AsyncImage(url: goods.itemUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    } placeholder: {
                        ProgressView()
                    }
                    Text(goods.itemName ?? "なし")
                    Text("\(goods.itemPrice?.description ?? "なし")円")
                }

            }
        }
    }
}

#Preview {
    RakutenView()
}
