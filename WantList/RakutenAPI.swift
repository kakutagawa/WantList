//
//  RakutenAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct Items: Codable {
    let items: [Item]

    struct Item: Codable {
        var itemName: String?
        var itemCaption: String?
        var itemPrice: String?
        var itemUrl: URL?

        enum CodingKeys: String, CodingKey {
            case itemName = "itemName"
            case itemCaption = "itemCaption"
            case itemPrice = "itemPrice"
            case itemUrl = "itemUrl"
        }
    }
}

final class GetRakutenItem: ObservableObject {
    @Published var rakutenGoods: [Items] = []
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
            let searchedResult = try decoder.decode(Items.self, from: data)

            let items = searchedResult.items
            rakutenGoods.removeAll()

            for item in items {
                if let itemName = item.itemName,
                   let itemCaption = item.itemCaption,
                   let itemPrice = item.itemPrice,
                   let itemUrl = item.itemUrl {
                    let rakutenItem = Items(items: [item])
                    self.rakutenGoods.append(rakutenItem)
                }
            }
        } catch {
            print("エラー: \(error)")
        }
    }
}
