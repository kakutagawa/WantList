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
        var price: Int?
        var code: String?
        var url: URL?
        var seller: Seller

        struct Seller: Codable, Hashable {
            var name: String?
        }

        var image: Image

        struct Image: Codable, Hashable {
            var medium: URL?
        }
    }
}

final class GetYahooItem: ObservableObject {
    @Published var yahooGoods: [WantItem] = []
    var yahooLink: URL?

    func searchYahoo(keyword: String, page: Int) {
        print("searchYahooメソッドで受け取った値 キーワード：\(keyword)、ページ：\(page)")
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
            string: "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=dj00aiZpPTdWWnNGSDFiOXhBSSZzPWNvbnN1bWVyc2VjcmV0Jng9ODg-&query=\(keyword_encode)&hits=\(pageNumber)"
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
                    id: item.code ?? "",
                    itemTitle: item.name,
                    itemPrice: "\(item.price ?? 0)",
                    itemUrl: item.url,
                    itemShopName: item.seller.name,
                    itemImageUrl: item.image.medium,
                    source: .yahoo
                )
            }
            yahooGoods.append(contentsOf: yahooItemsArray)

        } catch {
            print("エラー: \(error)")
        }
    }
}
