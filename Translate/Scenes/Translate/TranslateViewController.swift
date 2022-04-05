//
//  TranslateViewController.swift
//  Translate
//
//  Created by 노민경 on 2022/04/04.
//

import SnapKit
import UIKit

class TranslateViewController: UIViewController {
    // MARK: button
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("한국어", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 9.0
        
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("영어", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 9.0
        
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        
        [sourceLanguageButton, targetLanguageButton]
            .forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    // MARK: result
    private lazy var resultBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23.0, weight: .bold)
        label.textColor = UIColor.mainTintColor
        label.numberOfLines = 0

        return label
    }()
    
    private lazy var resultBookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        return button
    }()
    
    private lazy var resultCopyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        
        return button
    }()
    
    // MARK: source
    private lazy var sourceLabelBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        // UIView 타입인 경우 UIButton처럼 addTarget에 대한 response가 없다. 따라서 UITapGestureRecognizer로 UIButton처럼 탭 액션에 대한 동작을 구현한다.
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSourceLabelBaseView))
        view.addGestureRecognizer(tabGesture)
        
        return view
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23.0, weight: .semibold)
        label.numberOfLines = 0
        // placeholder
        label.text = "번역할 문자를 입력해주세요."
        label.textColor = .tertiaryLabel
        // TODO : sourceLabel에 입력값이 추가되면 placeholder 스타일 해제시키기
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        setupViews()
    }
}

// SourceTextViewController에서 설정한 delegate 프로토콜을 따르도록 설정
extension TranslateViewController: SourceTextViewControllerDelegate {
    func didEnterText(_ sourceText: String) {
        if sourceText == "" { return }
        
        sourceLabel.text = sourceText
        sourceLabel.textColor = .label
    }
}

private extension TranslateViewController {
    func setupViews() {
        [
            buttonStackView,
            resultBaseView, resultLabel, resultBookmarkButton, resultCopyButton,
            sourceLabelBaseView, sourceLabel
        ]
            .forEach { view.addSubview($0) }
        
        let defaultSpacing: CGFloat = 16.0
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(defaultSpacing)
            $0.trailing.equalToSuperview().inset(defaultSpacing)
            $0.height.equalTo(50.0)
        }

        resultBaseView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(defaultSpacing)
            $0.bottom.equalTo(resultBookmarkButton.snp.bottom).offset(defaultSpacing)
        }

        resultLabel.snp.makeConstraints {
            $0.leading.equalTo(resultBaseView.snp.leading).inset(24.0)
            $0.trailing.equalTo(resultBaseView.snp.trailing).inset(24.0)
            $0.top.equalTo(resultBaseView.snp.top).inset(24.0)
        }

        resultBookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(resultLabel.snp.leading)
            $0.top.equalTo(resultLabel.snp.bottom).offset(24.0)
            $0.width.equalTo(40.0)
            $0.height.equalTo(40.0)
        }

        resultCopyButton.snp.makeConstraints {
            $0.leading.equalTo(resultBookmarkButton.snp.trailing).inset(8.0)
            $0.top.equalTo(resultBookmarkButton.snp.top)
            $0.width.equalTo(40.0)
            $0.height.equalTo(40.0)
        }

        sourceLabelBaseView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(resultBaseView.snp.bottom).offset(defaultSpacing)
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0.0)
        }

        sourceLabel.snp.makeConstraints {
            $0.leading.equalTo(sourceLabelBaseView.snp.leading).inset(24.0)
            $0.trailing.equalTo(sourceLabelBaseView.snp.trailing).inset(24.0)
            $0.top.equalTo(sourceLabelBaseView.snp.top).inset(24.0)
        }
    }
    
    @objc func didTapSourceLabelBaseView() {
        let viewController = SourceTextViewController(delegate: self)
        present(viewController, animated: true)
    }
    
}
