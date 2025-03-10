//
//  LikedRepository.swift
//  Coini
//
//  Created by 이빈 on 3/11/25.
//

import Foundation
import RealmSwift

protocol LikedService {
    func getFileURL()
    func isExist(coinID: String) -> Bool
    func create(data: Liked)
    func delete(coinID: String)
}

final class LikedRepository: LikedService {
    
    let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    func isExist(coinID: String) -> Bool {
        let existItem = realm.objects(Liked.self).where({ $0.coinID == coinID }).first
        switch existItem {
        case .some(_):
            return true
        case .none:
            return false
        }
    }
    
    func create(data: Liked) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("realm에 데이터 추가를 실패하였습니다.")
        }
    }
    
    func delete(coinID: String) {
        guard let existItem = realm.objects(Liked.self).where({ $0.coinID == coinID }).first else {
            print("삭제할 데이터가 없습니다.")
            return
        }
        
        do {
            try realm.write {
                realm.delete(existItem)
            }
        } catch {
            print("realm에 데이터 삭제를 실패하였습니다.")
        }
    }
}
