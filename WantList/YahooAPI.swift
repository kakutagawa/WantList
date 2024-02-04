//
//  YahooAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct YahooGoods: Codable {

}

final class GetYahooItem: ObservableObject {
    @Published var yahooGoods: [YahooGoods] = []

    func getYahoo() async {
        guard let url = URL(string: "") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchedResult = try decoder.decode(YahooGoods.self, from: data)
            Task { @MainActor in
                self.yahooGoods = searchedResult
            }
        } catch {
            print("エラー: \(error)")
        }
    }
}
