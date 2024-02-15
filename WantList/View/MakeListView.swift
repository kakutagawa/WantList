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
    func transition()
}

final class AddButtonDidTap {
    var delegate: MakeListDelegate?
    func TappedButton() {
        guard let delegate = delegate else {
            return
        }
        delegate.transition()
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
        Form {
            Section(header: Text("タイトル")){
                TextField("タイトルを入力", text: $itemTitle)
            }
            Section(header: Text("メモ")){
                TextEditor(text: $itemCaption)
                    .overlay(alignment: .topLeading) {
                        if itemCaption.isEmpty {
                            Text("メモを入力")
                                .allowsHitTesting(false)
                                .foregroundStyle(Color(uiColor: .placeholderText))
                        }
                    }
            }
            Section(header: Text("値段")){
                TextField("値段", text: $itemPrice)
                    .keyboardType(.numberPad)
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
        addButtonDidTap.TappedButton()
    }
}

#Preview {
    MakeListView()
}
