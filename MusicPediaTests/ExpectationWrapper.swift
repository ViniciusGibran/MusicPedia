//
//  ExpectationWrapper.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 12/10/2020.
//

import XCTest

class ExpectationWrapper: XCTestExpectation {
    private var timer: Timer!
    var isSucceeded = false
    
    private var delay: TimeInterval! {
        didSet {
            self.timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(success), userInfo: nil, repeats: false)
        }
    }
    
    convenience init(successAfter d: TimeInterval, description: String) {
        self.init(description: description)
        defer {
            self.delay = d
        }
    }
    
    @objc func success() {
        fulfill()
    }
    
    override func fulfill() {
        isSucceeded = true
        super.fulfill()
    }
}
