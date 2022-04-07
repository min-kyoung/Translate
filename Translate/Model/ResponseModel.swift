//
//  ResponseModel.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Foundation

struct ResponseModel: Decodable {
    private let message: Message
    var translatedText: String { message.result.translatedText }
    
    // Message의 Result의 translatedText
    struct Message: Decodable {
        let result: Result
    }
    struct Result: Decodable {
        let translatedText: String
    }
}
