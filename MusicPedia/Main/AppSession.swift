//
//  AppSession.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit
import StoreKit

fileprivate struct LocalStorageKeys {
    private init() {}
    
    static let launchCount = "launch_count"
}

// TODO: Handle caches and local storage
class AppSession: NSObject {

    // MARK: Singleton
    // private
    private static var privateShared: AppSession?
    
    static var shared: AppSession {
        get {
            guard let shared = privateShared else {
                privateShared = AppSession()
                return privateShared!
            }
            return shared
        }
    }
    
    // MARK: Properties
    // private
    private let userDefaults = UserDefaults.standard
    
    // MARK: Init
    private override init() {
        super.init()
    }
    
    // finalize
    static func end() {
        privateShared = nil
    }

    // MARK: Methods
    func atemptToShowStoreReview() {
        let counter = userDefaults.integer(forKey: LocalStorageKeys.launchCount)+1
        
        if counter % 10 == 0 {
            SKStoreReviewController.requestReview()
            return
        }
        
        userDefaults.set(counter, forKey: LocalStorageKeys.launchCount)
    }
}
