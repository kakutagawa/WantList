//
//  AmazonAPI.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/02.
//

import Foundation

struct AmazonGoods: Codable {

}

final class GetAmazonItem: ObservableObject {
    @Published var amazonGoods: [AmazonGoods] = []

    func getAmazon() async {
        guard let url = URL(string: "") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let searchedResult = try decoder.decode(AmazonGoods.self, from: data)
            Task { @MainActor in
//                self.amazonGoods = searchedResult
            }
        } catch {
            print("エラー: \(error)")
        }
    }
}
