//
//  UserDefaults+.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Foundation

// Bookmark의 배열을 저장
extension UserDefaults {
    enum Key: String {
        case bookmarks
    }
    
    var bookmarks: [Bookmark] {
        get {
            // UserDefaults에 있는 데이터를 가져와 디코드해서 사용
            guard let data = UserDefaults.standard.data(forKey: Key.bookmarks.rawValue) else { return [] }
            
            return (try? PropertyListDecoder().decode([Bookmark].self, from: data)) ?? [] // 가져온 데이터를 Bookmark 배열로 변환
        }
        
        set{
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(newValue), forKey: Key.bookmarks.rawValue)
        }
    }
}
