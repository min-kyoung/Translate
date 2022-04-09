//
//  TranslateViewController.swift
//  Translate
//
//  Created by 노민경 on 2022/04/04.
//

import SnapKit
import UIKit

class TranslateViewController: UIViewController {
    private var translatorManager = TranslatorManager()

    // MARK: button
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle(translatorManager.sourceLanguage.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 9.0
        
        button.addTarget(self, action: #selector(didTapSourceLanguageButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle(translatorManager.targetLanguage.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 9.0
        
        button.addTarget(self, action: #selector(didTapTargetLanguageButton), for: .touchUpInside)
        
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
        button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func didTapBookmarkButton() {
        // bookmark 기능이 실행되기 위해서는 resultBaseView와 sourceLabelBaseView에 값이 있어야 함 (placeholder 상태에서는 실행되면 안됨)
        // 아이콘이 bookmark.fill이 되었는지에 따라서 bookrmark 여부를 구분
        guard
            let sourceText = sourceLabel.text,
            let resultText = resultLabel.text,
            resultBookmarkButton.imageView?.image == UIImage(systemName: "bookmark") // bookmark.fill == bookmark 된 상태
        else { return }
        
        resultBookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        
        // 현재의 배열에 새로운 값을 추가하는 것, 기존의 배열에 새로운 bookmark의 property를 정의해서 append 시켜줌
        let currentBookmarks: [Bookmark] = UserDefaults.standard.bookmarks
        let newBookmark = Bookmark(
            sourceLanguage: translatorManager.sourceLanguage,
            targetLanguage: translatorManager.targetLanguage,
            sourceText: sourceText,
            targetText: resultText
        )
        // UserDefaults에 새로운 값 저장
        UserDefaults.standard.bookmarks = [newBookmark] + currentBookmarks // newBookmark가 상위에 오도록 함
    }
    
    private lazy var resultCopyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.addTarget(self, action: #selector(didTapCopyButton), for: .touchUpInside)
    
        return button
    }()
    
    @objc func didTapCopyButton() {
        UIPasteboard.general.string = resultLabel.text
    }
    
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
        label.text = NSLocalizedString("Enter_Text", comment: "텍스트 입력")
        label.textColor = .tertiaryLabel
        
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
        
        translatorManager.request(from: sourceText) { [weak self] translatedText in
            self?.resultLabel.text = translatedText
        }
        
        // 새로운 값이 들어오면 bookmark 상태도 리셋
        resultBookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
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
    
    // 바꾸려는 언어가 sourceLanguage인지 targetLanguage인지 구분을 해주기 위해 누구를 바꿀지 기억할 수 있도록 하는 파라미터 Category를 만듦
    func didTapLanguageButton(type: Category) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        Language.allCases.forEach { language in
            let action = UIAlertAction(title: language.title, style: .default) { [weak self] _ in
                switch type {
                case .source:
                    self?.translatorManager.sourceLanguage = language
                    self?.sourceLanguageButton.setTitle(language.title, for: .normal)
                case .target:
                    self?.translatorManager.targetLanguage = language
                    self?.targetLanguageButton.setTitle(language.title, for: .normal)
                }
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "취소하기"),
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func didTapSourceLanguageButton() {
        didTapLanguageButton(type: .source)
    }
    
    @objc func didTapTargetLanguageButton() {
        didTapLanguageButton(type: .target)
    }
    
}
