//
//  BookmarkTextStackView.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import SnapKit
import UIKit

class BookmarkTextStackView: UIStackView {
    private let category: Category
    private let language: Language
    private let text: String
    
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = category.color
        label.text = language.title
   
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = category.color
        label.text = text
        label.numberOfLines = 0
        
        return label
    }()

    init(language: Language, text: String, category: Category) {
        self.language = language
        self.text = text
        self.category = category
    
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        axis = .vertical
        distribution = .equalSpacing
        spacing = 4.0
        
        [languageLabel, textLabel].forEach { addArrangedSubview($0) }
    }
}




