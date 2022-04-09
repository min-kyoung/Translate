//
//  SourceTextViewController.swift
//  Translate
//
//  Created by 노민경 on 2022/04/05.
//

import UIKit
import SnapKit

protocol SourceTextViewControllerDelegate: AnyObject {
    func didEnterText(_ sourceText: String)
}

class SourceTextViewController: UIViewController {
    private let placeholderText = NSLocalizedString("Enter_Text", comment: "텍스트 입력")
    
    private weak var delegate: SourceTextViewControllerDelegate?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        // placeholder
        textView.text = placeholderText
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 18.0, weight: .semibold)
        textView.returnKeyType = .done // "완료"로 표시
        textView.delegate = self
        return textView
    }()
    
    // delegate를 TranslateViewController에서 initialize하는 타이밍에 주입할 수 있도록 init method 생성
    init(delegate: SourceTextViewControllerDelegate?) { // delegate 값을 주입해야하므로 파라미터로 만듦
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
            
        }
    }
}

extension SourceTextViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // "완료" 키의 값이 들어왔을 때, dismiss
        guard text == "\n" else { return true }
        
        delegate?.didEnterText(textView.text)
        dismiss(animated: true)
        
        return true
    }
}
