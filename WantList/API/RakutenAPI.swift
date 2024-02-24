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
                var mediumImageUrls: [MediumImageUrls]?

            struct MediumImageUrls: Codable, Hashable {
                var imageUrl: URL?
            }
        }
    }
}

final class GetRakutenItem: ObservableObject {
    @Published var rakutenGoods: [RakutenItems.Item.ItemDetail] = []
    var rakutenLink: URL?

    func searchRakuten(keyword: String) {
        print("searchRakutenメソッドで受け取った値：\(keyword)")
        Task {
            await search(keyword: keyword)
        }
    }
    @MainActor
    private func search(keyword: String) async {
        guard let keyword_encode = keyword.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return
        }

        guard let url = URL(
            string: "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601?applicationId=1047553679060215294&keyword=\(keyword_encode)"
        ) else {
            return
        }
        print(url)

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchedResult = try decoder.decode(RakutenItems.self, from: data)

            let items = searchedResult.items.map(\.item)
            rakutenGoods = items
        } catch {
            print("エラー: \(error)")
        }
    }
}
