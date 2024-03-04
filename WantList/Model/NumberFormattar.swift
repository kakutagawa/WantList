//
//  NumberFormattar.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/03/04.
//

import Foundation

extension Int {
    var withCommaString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
