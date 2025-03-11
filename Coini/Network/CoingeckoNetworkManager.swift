//
//  CoingeckoNetworkManager.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class CoingeckoNetworkManager {
    
    static let shared = CoingeckoNetworkManager()
    
    private init() { }
    
    func getTrending<T: Decodable>(api: Router,
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
                print("🐊🐊CoinGecko API 통신!🐊🐊")
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    if let code = error.responseCode {
                        single(.failure(AFError.geckoError(code: code)))
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
