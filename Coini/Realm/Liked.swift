//
//  Liked.swift
//  Coini
//
//  Created by 이빈 on 3/11/25.
//

import Foundation
import RealmSwift

final class Liked: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var coinID: String
    @Persisted var isSelected: Bool
    
    convenience init(coinID: String, isSelected: Bool) {
        self.init()
        self.coinID = coinID
        self.isSelected = isSelected
    }
}
