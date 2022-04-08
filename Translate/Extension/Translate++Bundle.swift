//
//  Translate++Bundle.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Foundation

extension Bundle {
    var secretKey: String {
        guard let file = self.path(forResource: "TranslateInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["Secret_Key"] as? String else { fatalError("TranslateInfo.plist에 Secret_Key 설정을 해주세요.")}
        return key
    }
}
