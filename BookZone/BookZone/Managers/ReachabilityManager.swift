//
//  ReachabilityManager.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 12.03.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

class ReachabilityManager {
    static let shared = ReachabilityManager()

    func hasConnectivity() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
}
