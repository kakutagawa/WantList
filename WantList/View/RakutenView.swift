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
            }
        }
    }
}

#Preview {
    RakutenView()
}
