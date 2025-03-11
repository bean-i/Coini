//
//  NetworkMonitor.swift
//  Coini
//
//  Created by 이빈 on 3/8/25.
//

import Foundation
import RxSwift
import RxCocoa
import Network

enum NetworkStatusType {
    case disconnect
    case connect
    case unknown
}

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private init() { }
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    let wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    
    
    let networkStatus = BehaviorRelay(value: NetworkStatusType.unknown)
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("connected")
                
                if path.usesInterfaceType(.cellular) {
                    print("셀룰러")
                    self.networkStatus.accept(.connect)
                } else if path.usesInterfaceType(.wifi) {
                    print("와이파이")
                    self.networkStatus.accept(.connect)
                } else if path.usesInterfaceType(.wiredEthernet) {
                    print("유선연결")
                    self.networkStatus.accept(.connect)
                } else {
                    print("기타")
                    self.networkStatus.accept(.connect)
                }
            } else {
                print("끊김")
                self.networkStatus.accept(.disconnect)
            }
        }
        self.monitor.start(queue: DispatchQueue.global())
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
