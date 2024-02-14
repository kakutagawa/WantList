//
//  MakeListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI

class ItemList: ObservableObject {
    @Published var itemList: [WantItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(itemList) {
                UserDefaults.standard.set(encoded, forKey: "itemList")
            }
        }
    }

    init() {
        if let savedData = UserDefaults.standard.data(forKey: "itemList") {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([WantItem].self, from: savedData) {
                itemList = loadedData
                return
            }
        }
        itemList = []
    }
}

protocol MakeListDelegate {
    func transition(item: WantItem)
}

final class AddButtonDidTap {
    var delegate: MakeListDelegate?
    func TappedButton(item: WantItem) {
        guard let delegate = delegate else {
            return
        }
        delegate.transition(item: item)
    }
}

struct MakeListView: View {
    @EnvironmentObject var items: ItemList
    @State var itemTitle: String = ""
    @State var itemCaption: String = ""
    @State var itemPrice: String = ""
    @Environment(\.presentationMode) var presentationMode
    var addButtonDidTap = AddButtonDidTap()

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
            Button {
                addItemList()
            } label: {
                Text("追加")
            }
        }
    }

    private func addItemList() {
        let newItem = WantItem(id: 1, itemtitle: itemTitle, itemCaption: itemCaption, itemPrice: itemPrice)
        items.itemList.append(newItem)
        itemTitle = ""
        itemCaption = ""
        itemPrice = ""
        presentationMode.wrappedValue.dismiss()
        addButtonDidTap.TappedButton(item: newItem)
    }
}

#Preview {
    MakeListView()
}
