//
//  BookmarkCollectionViewCell.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import UIKit
import SnapKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookmarkCollectionViewCell"
    
    // BookmarkListViewController에서 setUp 메서드를 호출한 후 cell을 return 하기 때문에 이 값들은 무조건 있는 값들이라고 판단
    private var sourceBookmarkTextStackView: BookmarkTextStackView!
    private var targetBookmarkTextStackView: BookmarkTextStackView!
    
    private lazy var stackView: UIStackView = {
        let inset: CGFloat = 16.0
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = inset
        
        // stackView 자체에 inset 설정
        stackView.layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        stackView.isLayoutMarginsRelativeArrangement = true
       
        return stackView
    }()
    
    func setUp(from bookmark: Bookmark) {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12.0
    
        // 새로운 bookmark 값
        sourceBookmarkTextStackView = BookmarkTextStackView(language: bookmark.sourceLanguage, text: bookmark.sourceText, category: .source)
        targetBookmarkTextStackView = BookmarkTextStackView(language: bookmark.targetLanguage, text: bookmark.targetText, category: .target)
        
        // stackView의 subview 자체를 아예 새로 그림
        stackView.subviews.forEach { $0.removeFromSuperview() } // 이전에 남아 있는 것이 쌓이기 때문에 아예 삭제 후
        [sourceBookmarkTextStackView, targetBookmarkTextStackView].forEach { stackView.addArrangedSubview($0) } // 다시 추가
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width - 32.0)
        }
        
        // layout을 한 번 더 업데이트
        layoutIfNeeded()
    }
    
    
}
