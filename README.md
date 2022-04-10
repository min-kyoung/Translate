# Translate
## Description
* 번역 탭, 즐겨찾기 탭으로 구성되어 있다.
* 번역 탭에서는 번역할 값을 입력하고 네트워크를 통해 가져온 번역된 결과를 화면으로 보여준다.
	* 상단의 언어변경 버튼을 누르면 한국어, 영어, 일본어, 중국어로 번역할 언어를 선택할 수 있는 액션 시트가 나온다.
* 즐겨찾기 탭에서는 번역 탭에서 번역 후 북마크 표시를 선택한 문장을 보여준다.
* 또한 디바이스에 설정된 언어에 따라서 앱에 표시되는 언어도 변경되는 다국어 기능도 구현한다.
#### 구현화면
* 디바이스 언어가 영어인 경우 <br>
<img src="https://user-images.githubusercontent.com/62936197/162595099-28094aaa-489f-472f-ab0d-90e58b0d437a.png" width="150" height="320"> 　　<img src="https://user-images.githubusercontent.com/62936197/162595103-af38c116-0219-477f-a448-f09def2d0c1e.png" width="150" height="320"> 　<img src="https://user-images.githubusercontent.com/62936197/162595104-8aa343b7-f514-49d6-950e-71c4f250a984.png" width="150" height="320"> <img src="https://user-images.githubusercontent.com/62936197/162595152-b3d489e8-7fb9-4b28-bd5c-eed6b3339bd0.png" width="150" height="320"> 　
* 번역할 언어 변경 <br>
<img src="https://user-images.githubusercontent.com/62936197/162595167-f1bf1c5b-1924-4dbf-882e-5dfa3cdf0302.png" width="150" height="320"> 　<img src="https://user-images.githubusercontent.com/62936197/162595169-612ce401-a42e-4b5f-bea1-f281cf4b3bb1.png" width="150" height="320"> 　
* 디바이스 언어가 한국어인 경우 <br>
<img src="https://user-images.githubusercontent.com/62936197/162595171-9ae3b1d9-c48b-42a7-877b-e620e78707a7.png" width="150" height="320"> 　<img src="https://user-images.githubusercontent.com/62936197/162595172-05350468-5e9c-4be5-a0f5-35eda85504d4.png" width="150" height="320"> 　

## Prerequisite
* XCode Version 13.2.1에서 개발을 진행하였다. 
* 프로젝트에 openAPI를 설치한다.
  * 오토 레이아웃을 코드로 설정하기 위한 SnapKit과 파파고 API를 request method로 구현하기 위한 Alamofire를 Swift Package Manager를 통해 설치한다.
  * File > Add Packages에서 아래 URL을 입력하여 설치한다.
    ```swift
    github.com/SnapKit/SnapKit.git
    github.com/Alamofire/Alamofire.git
    ```
* 파파고 API 키 받아오기
  * https://developers.naver.com/products/papago/nmt/nmt.md 에서 **오픈 API 이용 신청**을 한다.
  * 애플리케이션 등록시 '비로그인 오픈 API 서비스 환경'에서 **iOS 설정 추가** 후 **프로젝트의 Bundle ID**를 입력한다.
## Usage
#### 파파고 API 
* Papago의 인공 신경망 기반 기계 번역 기술(NMT, Neural Machine Translation)로 텍스트를 번역한 결과를 반환하는 RESTful API이다.
* Request URL : https://openapi.naver.com/v1/papago/n2mt
* HTTP Method : POST
* Parameter
  * Key: source (원본 언어의 언어코드)
  * Key: target (목적 언어의 언어코드)
  * Key: text (번역할 텍스트)
* 반드시 필요한 Request parameter
  ```swift
  struct RequestModel: Codable {
      let source: String
      let target: String
      let text: String
  }
  ```
* 반드시 필요한 Response parameter 
  ```swift
  struct ResponseModel: Decodable {
      private let message: Message
      var translatedText: String { message.result.translatedText } // 편하게 꺼내쓰기 위한 변수

      // Message의 Result의 translatedText
      struct Message: Decodable {
          let result: Result
      }
      
      struct Result: Decodable {
          let translatedText: String
      }
  }
  ```
* Requset method 구현 (번역 네트워크 통신 구현)
  ```swift
  struct TranslatorManager {
    var sourceLanguage: Language = .ko
    var targetLanguage: Language = .en
    
     func request(from text: String, completionHandler: @escaping (String) -> Void ) {
        guard let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt") else { return } // => url이 존재한다는 전재
        
        let requestModel = RequestModel(
            source: sourceLanguage.languageCode,
            target: targetLanguage.languageCode,
            text: text
        )
        
        let secretAPI = Bundle.main.secretKey
        
        // header를 dictionary로 만듦
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "NHYRCkYdKQwVV8Zg_9Da", //client id
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
  ```
#### Localization
* iOS 앱에서 표시되는 텍스트, 이미지, 날짜, 가격 및 통화 기호를 나라별로 다르게 표시될 수 있게 구현하는 국제화를 위한 최적화 방법이다. 

## Files 
> Translate
* TranslateViewController
  * 번역 탭을 구현한 화면이다. 
  * SourceTextViewController에서 받아온 텍스트를 설정된 언어에 맞게 번역하여 보여준다. 
* SourceTextViewController
  * 텍스트를 입력할 수 있도록 구현한 화면이다.
> Bookmark
* BookmarkListViewController
  * 북마크 탭을 구현한 화면이다.
* BookmarkCollectionViewCell
  * source 언어에 대한 stackView와 target 언어에 대한 stackView를 쌓아 하나의 셀로 구현한다. 
* BookmarkTextStackView
   * 북마크 셀에 들어갈 stackView를 구현한다. 
