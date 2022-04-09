//
//  BookmarkListViewController.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import UIKit
import SnapKit

class BookmarkListViewController: UIViewController {
    private var bookmark: [Bookmark] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 16.0
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32, height: 100.0) // 셀의 최소 사이즈
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset) // layout의 inset
        layout.minimumLineSpacing = inset // 줄의 최소 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.dataSource = self
        return collectionView
        
    }()
    
    // 배열의 경우 별도로 reload를 해주어야 새로운 값을 볼 수 있다.
    // viewDidLoad는 ViewController가 초기화 되었을 때, 한 번만 실행되기 때문에 다른 탭을 갔다 오면 reload가 되어있지 않을 것이다.
    // 따라서 다른 탭을 갔다왔을 때 최신 정보를 보여주기 위해서 viewWillAppear를 사용한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        
        navigationItem.title = NSLocalizedString("Bookmark", comment: "즐겨찾기")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // bookmark 값을 새로 가져오는 타이밍에 viewWillAppear를 사용한다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bookmark = UserDefaults.standard.bookmarks
        collectionView.reloadData() // 새로운 bookmark의 값을 기준으로 collectionView도 새로 그려줌
    }
}

extension BookmarkListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookmark.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell
        
        let bookmark = bookmark[indexPath.item]
        cell?.setUp(from: bookmark)
        
        return cell ?? UICollectionViewCell()
    }
}

private extension BookmarkListViewController {
    func setUpLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
