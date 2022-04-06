//
//  Language.swift
//  Translate
//
//  Created by 노민경 on 2022/04/05.
//

import Foundation

// enum을 array로 활용하여 actionSheet에 추가하기 위해 CaseIterable 사용
// enum에서 Codable을 사용할 경우 String 값을 rawValue로 사용할 수 있도록 해야한다.
enum Language: String, CaseIterable, Codable {
    case ko
    case en
    case ja
    case ch
    
    var title: String {
        switch self {
        case .ko: return "한국어"
        case .en: return "영어"
        case .ja: return "일본어"
        case .ch: return "중국어"
        }
    }
}
