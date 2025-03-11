//
//  UpbitNetworkManager.swift
//  Coining
//
//  Created by 이빈 on 3/6/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class UpbitNetworkManager {
    
    static let shared = UpbitNetworkManager()
    
    private init() { }
    
    func getTickers<T: Decodable>(api: Router,
                                  type: T.Type) -> Single<T> {
        return Single.create { single in
            guard let endpoint = api.endpoint else {
                single(.failure(AFError.invalidURL))
                return Disposables.create {
                    print("통신 종료")
                }
            }
            
            AF.request(endpoint,
                       method: api.method,
                       parameters: api.parameters,
                       encoding: URLEncoding.queryString)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    if let data = response.data {
                        do {
                            let decodeData = try JSONDecoder().decode(UpbitError.self, from: data)
                            single(.failure(AFError.upbitError(message: decodeData.error)))
                        } catch { // alamofire 에러
                            single(.failure(AFError.afError))
                        }
                    } else {
                        single(.failure(AFError.afError))
                    }
                }
            }
            
            return Disposables.create {
                print("통신 종료")
            }
        }
    }
}
