//
//  RakutenAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct RakutenItems: Codable {
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }

    struct Item: Codable {
        let item: ItemDetail
            enum CodingKeys: String, CodingKey {
                case item = "Item"
            }

        struct ItemDetail: Codable, Hashable {
                var itemName: String?
                var itemPrice: Int?
                var itemUrl: URL?
                var itemCode: String?
                var mediumImageUrls: [MediumImageUrls]?

            struct MediumImageUrls: Codable, Hashable {
                var imageUrl: URL?
            }
        }
    }
}

final class GetRakutenItem: ObservableObject {
    @Published var rakutenGoods: [WantItem] = []
    var rakutenLink: URL?

    func searchRakuten(keyword: String, page: Int) {
        print("searchRakutenメソッドで受け取った値 キーワード：\(keyword)、ページ：\(page)")
        Task {
            await search(keyword: keyword, page: page)
        }
    }
    @MainActor
    private func search(keyword: String, page: Int) async {
        guard let keyword_encode = keyword.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return
        }
        var pageNumber = page

        guard let url = URL(
            string: "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601?applicationId=1047553679060215294&keyword=\(keyword_encode)&page=\(pageNumber)"
        ) else {
            return
        }
        print(url)

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchedResult = try decoder.decode(RakutenItems.self, from: data)
            let searchedResultArray = searchedResult.items.map(\.item)

            let rakutenItemsArray = searchedResultArray.map { item in
                WantItem(
                    id: item.itemCode ?? "",
                    itemTitle: item.itemName,
                    itemCaption: "",
                    itemPrice: "\(item.itemPrice ?? 0)",
                    itemUrl: item.itemUrl,
                    itemImageUrl: item.mediumImageUrls?.first?.imageUrl,
                    source: .rakuten
                )
            }
            rakutenGoods.append(contentsOf: rakutenItemsArray)
        } catch {
            print("エラー: \(error)")
        }
    }
}
