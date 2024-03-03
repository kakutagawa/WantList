//
//  RakutenAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct YahooItems: Codable {
    let hits: [Hits]

    struct Hits: Codable, Hashable {
        var name: String?
        var description: String?
        var price: Int?
        var url: URL?
        var image: Image

        struct Image: Codable, Hashable {
            var medium: URL?
        }
    }
}

final class GetYahooItem: ObservableObject {
    @Published var yahooGoods: [WantItem] = []
    var yahooLink: URL?

    func searchYahoo(keyword: String) {
        print("searchYahooメソッドで受け取った値：\(keyword)")
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
            string: "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=dj00aiZpPTdWWnNGSDFiOXhBSSZzPWNvbnN1bWVyc2VjcmV0Jng9ODg-&query=\(keyword_encode)"
        ) else {
            return
        }
        print(url)

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchedResult = try decoder.decode(YahooItems.self, from: data)
            let searchedResultArray = searchedResult.hits

            let yahooItemsArray = searchedResultArray.map { item in
                WantItem(
                    id: item.hashValue,
                    itemTitle: item.name,
                    itemCaption: item.description,
                    itemPrice: "\(item.price ?? 0)",
                    itemUrl: item.url,
                    itemImageUrl: item.image.medium
                )
            }
            yahooGoods.append(contentsOf: yahooItemsArray)

        } catch {
            print("エラー: \(error)")
        }
    }
}
