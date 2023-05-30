//
//  NetworkConnectivity.swift
//  YayOrNay
//
//  Created by MyAList on 1/5/19.
//  Copyright © 2019 Mahmoud Fathy. All rights reserved.
//

import Alamofire

class NetworkConnectivity {
    static let shared = NetworkConnectivity()
    
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    private init() {}
    
    var lastStatus: NetworkReachabilityManager.NetworkReachabilityStatus?
    var currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus?
    
    func startNetworkReachabilityObserver() {
        var networkStatusMessage: String?
        self.reachabilityManager?.startListening(onUpdatePerforming: { status in
            if self.currentStatus != nil {
                self.lastStatus = self.currentStatus
            }
            
            self.currentStatus = status
            switch status {
            case .notReachable:
                networkStatusMessage = "network"
            case .unknown:
                networkStatusMessage = "unknown.connection.error"
            case .reachable(.ethernetOrWiFi):
                networkStatusMessage = "connected.wifi"
            case .reachable(.cellular):
                networkStatusMessage = "connected.wwan"
            }
            
            print("Network Status\(networkStatusMessage ?? "")")

        })
        
        
    }
}
