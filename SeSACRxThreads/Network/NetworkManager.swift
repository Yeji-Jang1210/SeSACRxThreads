//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 장예지 on 8/11/24.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case decodeError
}

final class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init(){}
    
    func networking(date: String) -> Single<Movie> {
        let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIInfo.key)&targetDt=\(date)"
        
        return Single.create { single -> Disposable in
            AF.request(url).responseDecodable(of: Movie.self) { response in
                switch response.result {
                case .success(let success):
                    single(.success(success))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}

