//
//  TagView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/03/18.
//

import SwiftUI

protocol TagViewDelegate {
    func transitionMakeTagView()
}

struct TagView: View {
    @EnvironmentObject var tags: TagList
    var tagViewDelegate: TagViewDelegate?
    @State private var selectedTag: ItemTag = ItemTag(tagTitle: "未設定", tagColor: .clear)

    var body: some View {
        LazyVStack {
            Text(selectedTag.tagTitle ?? "")
                .background(Color(selectedTag.tagColor.rawValue))
            List {
                ForEach(tags.tagList, id: \.self) { tag in
                    HStack {
                        Circle()
                            .fill(Color(tag.tagColor.rawValue))
                        Text(tag.tagTitle ?? "")
                        Spacer()

                    }
                    Button {
                        tagViewDelegate?.transitionMakeTagView()
                    } label: {
                        HStack {
                            Image(systemName: "plus.app.fill")
                            Text("新規作成")
                        }
                    }
                }
            }
        }
    }
}
