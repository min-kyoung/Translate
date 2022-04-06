//
//  Category.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Foundation
import UIKit

enum Category {
    case source
    case target
    
    var color: UIColor {
        switch self {
        case .source: return .label
        case .target: return .mainTintColor
        }
    }
}
