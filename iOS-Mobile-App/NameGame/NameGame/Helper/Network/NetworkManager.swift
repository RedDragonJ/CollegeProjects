//
//  NetworkManager.swift
//  URLtest
//
//  Created by James on 3/9/18.
//  Copyright © 2018 James Layton. All rights reserved.
//

import Foundation
import CoreTelephony

enum NetworkStatus {
    case NoNetwork
    case Wifi
    case FourG
    case OtherNetwork
    case Unknown
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init(){}
    
    func checkStatus(completion: @escaping (_ status: NetworkStatus) -> Void) {
        if let reachability = Reachability.forInternetConnection() {
            reachability.startNotifier()
            let status = reachability.currentReachabilityStatus()
            if status == .init(0) {
                // NotReachable
                completion(NetworkStatus.NoNetwork)
            }
            else if status == .init(1) {
                // ReachableViaWiFi
                completion(NetworkStatus.Wifi)
            }
            else if status == .init(2) {
                // ReachableViaWWAN
                let netInfo = CTTelephonyNetworkInfo()
                if let cRAT = netInfo.currentRadioAccessTechnology {
                    switch cRAT {
                    case CTRadioAccessTechnologyGPRS,
                         CTRadioAccessTechnologyEdge,
                         CTRadioAccessTechnologyCDMA1x,
                         CTRadioAccessTechnologyWCDMA,
                         CTRadioAccessTechnologyHSDPA,
                         CTRadioAccessTechnologyHSUPA,
                         CTRadioAccessTechnologyCDMAEVDORev0,
                         CTRadioAccessTechnologyCDMAEVDORevA,
                         CTRadioAccessTechnologyCDMAEVDORevB,
                         CTRadioAccessTechnologyeHRPD:
                        // Reachable Via Edge, 2G, 3G, etc.
                        completion(NetworkStatus.OtherNetwork)
                    case CTRadioAccessTechnologyLTE:
                        // Reachable Via 4G
                        completion(NetworkStatus.FourG)
                    default:
                        completion(NetworkStatus.Unknown)
                        break
                    }
                }
            }
        }
    }
    
    func requestDataWith(urlStr: String, completion: @escaping (_ value: Data?, _ response: URLResponse?, _ error: String?) -> Void) {
        guard let url = URL.init(string: urlStr) else {
            DispatchQueue.main.async {
                completion(nil, nil, "ERROR: Invalid url string")
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error { // There is a error
                print("##### ", err, " #####")
                DispatchQueue.main.async {
                    completion(nil, response, "ERROR: failed request data")
                }
            }
            else { // There is no error
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, response, "ERROR: Failed to retrieve data")
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(data, nil, nil)
                }
            }
        }.resume()
    }
}
