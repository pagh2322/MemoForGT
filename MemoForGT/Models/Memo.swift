//
//  Memo.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import Foundation

struct Memo: Hashable, Codable, Identifiable {
    var id: Int
    var content: String
    var isSecret: Bool = false
    var password: String?
}
