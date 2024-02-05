//
//  RakutenAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct Items: Identifiable {
    let id = UUID()
    let itemName: String
    let itemCaption: String
    let itemPrice: String
    let itemURL: URL
}
final class GetRakutenItem: ObservableObject {
    private struct ResultJson: Codable {
        struct Item: Codable {
            var itemName: String?
            var itemCaption: String?
            var itemPrice: String?
            var itemURL: URL?
        }
        let item: [Item]?
    }


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
            let searchedResult = try decoder.decode(ResultJson.self, from: data)

            guard let items = searchedResult.item else { return }
            rakutenGoods.removeAll()

            for item in items {
                if let itemName = item.itemName,
                   let itemCaption = item.itemCaption,
                   let itemPrice = item.itemPrice,
                   let itemURL = item.itemURL {
                    let rakutenItem = Items(itemName: itemName, itemCaption: itemCaption, itemPrice: itemPrice, itemURL: itemURL)
                    self.rakutenGoods.append(rakutenItem)
                }
            }
        } catch {
            print("エラー: \(error)")
        }
    }
}
