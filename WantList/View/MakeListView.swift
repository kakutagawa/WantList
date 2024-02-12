//
//  MakeListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI

struct MakeListView: View {
    @State var itemTitle: String = ""
    @State var itemCaption: String = ""
    @State var itemPrice: String = ""

    var body: some View {
        VStack {
            TextField("タイトル", text: $itemTitle)
                .font(.system(size: 40))
                .foregroundStyle(Color.black)
                .frame(width: .infinity, height: 40)
            TextEditor(text: $itemCaption)
                .frame(width: .infinity, height: 100)
                .overlay(alignment: .topLeading) {
                    if itemCaption.isEmpty {
                        Text("メモ")
                            .allowsHitTesting(false)
                            .foregroundStyle(Color(uiColor: .placeholderText))
                            .padding(6)
                    }
                }
            HStack {
                TextField("値段", text: $itemPrice)
                    .keyboardType(.numberPad)
                    .font(.system(size: 40))
                    .foregroundStyle(Color.black)
                    .frame(height: 40)
                Text("円")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.black)
                    .frame(height: 40)
            }
        }
    }
}

#Preview {
    MakeListView()
}
