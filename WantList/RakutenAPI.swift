//
//  RakutenAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct Items: Codable {
    var number: [Number]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKey.self)
        self.number = try container.decodeIfPresent([Number].self, forKey: .number)

        let numberContainer = try container.nestedContainer(keyedBy: RootCodingKey.self, forKey: .number)
        var _number: [Number] = []
        try numberContainer.allKeys.forEach { key in
            let numberContainer = try numberContainer.nestedContainer(keyedBy: NumberCodingKey.self, forKey: RootCodingKey(stringValue: key.stringValue)!
            )
            let count = try numberContainer.decode(Int.self, forKey: NumberCodingKey.count)
            _number.append(Number())
        }
        self.number = _number
    }

    private struct RootCodingKey: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }

        static let number = RootCodingKey(intValue: number)!
    }
    private enum NumberCodingKey: String, CodingKey {
        case Item
    }
}

struct Number: Codable {
    var count: Int
    var item: Item?
}
struct Item: Codable {
    var itemName: String?
    var itemCaption: String?
    var itemURL: URL?
}

final class GetRakutenItem: ObservableObject {
    @Published var rakutenGoods: [Items] = []

    func getRakuten() async {
        guard let url = URL(string: "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601?applicationId=1047553679060215294&keyword=%E7%A6%8F%E8%A2%8B&sort=%2BitemPrice") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchedResult = try decoder.decode(Items.self, from: data)
            Task { @MainActor in
                self.rakutenGoods = searchedResult
            }
        } catch {
            print("エラー: \(error)")
        }
    }
}

