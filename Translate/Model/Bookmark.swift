//
//  Bookmark.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Foundation

// UserDefaults에는 번역 전 텍스트 값, 번역 전 텍스트 언어, 번역된 텍스트 값, 번역된 텍스트의 언어를 하나의 bookmark라는 모델로 만들어 저장한다.
struct Bookmark: Codable {
    let sourceLanguage: Language
    let targetLanguage: Language
    
    let sourceText: String
    let targetText: String
}
