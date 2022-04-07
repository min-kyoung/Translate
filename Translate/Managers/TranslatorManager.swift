//
//  TranslatorManager.swift
//  Translate
//
//  Created by 노민경 on 2022/04/06.
//

import Alamofire
import Foundation

struct TranslatorManager {
    var sourceLanguage: Language = .ko
    var targetLanguage: Language = .en
    
    func request(from text: String, completionHandler: @escaping (String) -> Void ) {
        guard let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt") else { return }
        // => url이 존재한다는 전재
        
        let requestModel = RequestModel(
            source: sourceLanguage.languageCode,
            target: targetLanguage.languageCode,
            text: text
        )
        
        let clientAPI = Bundle.main.clientKey
        let secretAPI = Bundle.main.secretKey
        
        // header를 dictionary로 만듦
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "\(clientAPI)", //client id
            "X-Naver-Client-Secret": "\(secretAPI)" // secret id
        ]
        
        AF
            .request(url, method: .post, parameters: requestModel, headers: headers)
            .responseDecodable(of: ResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result.translatedText)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
        
    }
}
