//
//  ListView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/01.
//

import SwiftUI

protocol ListViewDelegate {
    func transitionListDetailView(item: WantItem)
    func transitionMakeListView()
    func transitionSearchView()
}

struct ListView: View {
    @EnvironmentObject var items: ItemList
    var listViewDelegate: ListViewDelegate?

    var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                ScrollView {
                    ForEach(items.itemList) { item in
                        Button {
                            listViewDelegate?.transitionListDetailView(item: item)
                        } label: {
                            HStack{
                                if let image = item.itemImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(maxWidth: 100, maxHeight: 100)
                                        .padding(.leading, 10)
                                } else {
                                    Text("No Image")
                                        .font(Font.system(size: 24).bold())
                                        .foregroundColor(Color.white)
                                        .frame(width: 100, height: 100)
                                        .background(Color(UIColor.lightGray))
                                        .padding(.leading, 10)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(item.itemtitle ?? "なし")
                                        .font(.headline)
                                        .foregroundStyle(Color("TextColor"))
                                    Spacer()
                                    Text("¥\(item.itemPrice ?? "なし")")
                                }
                                Button {
                                    items.itemList.remove(at: item.id - 1)
                                } label: {
                                    Image(systemName: "trash.circle.fill")
                                }
                            }
                        }
                        .frame(maxHeight: 120)
                        Divider()
                    }
                }
            }
            HStack(spacing: 25) {
                Spacer()
                //新規作成
                Button {
                    listViewDelegate?.transitionMakeListView()
                } label: {
                    Image(systemName: "square.and.pencil.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .foregroundStyle(Color.pink)
                }
                //ネットショップから検索
                Button {
                    listViewDelegate?.transitionSearchView()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .foregroundStyle(Color.pink)
                }
                .padding(.trailing, 30)
            }
        }
    }
}

#Preview {
    ListView()
        .environmentObject(ItemList())
}
