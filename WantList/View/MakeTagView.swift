//
//  MakeTagView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/03/19.
//

import SwiftUI

struct MakeTagView: View {
    @State private var newTagTitle: String = ""
    @State private var newTagColor: TagColor = .clear
    @EnvironmentObject var tags: TagList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("タグ名を入力", text: $newTagTitle)

            ForEach(TagColor.allCases, id: \.self) { tagColor in
                Button {
                    self.newTagColor = tagColor
                } label: {
                    Circle()
                        .fill(tagColor.color)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: newTagColor == tagColor ? 3 : 0)
                        )
                }
            }
            Button {
                addTagList()
            } label: {
                Text("追加")
            }
        }
    }
    private func addTagList() {
        let newTag = ItemTag(
            tagTitle: newTagTitle,
            tagColor: newTagColor
        )
        tags.tagList.append(newTag)
        newTagTitle = ""
        newTagColor = .clear
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    MakeTagView()
}
