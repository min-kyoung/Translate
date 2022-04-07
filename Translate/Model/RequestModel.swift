//
//  RequestModel.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Foundation

struct RequestModel: Codable {
    let source: String
    let target: String
    let text: String
}
