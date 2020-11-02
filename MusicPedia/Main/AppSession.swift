//
//  AppSession.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

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
    private let launchTimesUntilShowStoreReview = 10
    
    // public
    var shouldShowStoreReview: Bool {
        let counter = userDefaults.integer(forKey: LocalStorageKeys.launchCount)
        return counter == launchTimesUntilShowStoreReview
    }
    
    // MARK: Init
    private override init() {
        super.init()
        self.updateLaunchCount()
    }
    
    // finalize
    static func end() {
        privateShared = nil
    }
    
    // start
    static func start() {
        privateShared = AppSession()
    }

    // MARK: Methods
    private func updateLaunchCount() {
        let counter = userDefaults.integer(forKey: LocalStorageKeys.launchCount)+1
        userDefaults.set(counter, forKey: LocalStorageKeys.launchCount)
    }
}
