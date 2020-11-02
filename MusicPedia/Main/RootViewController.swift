//
//  RootViewController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit
import StoreKit
import Combine

class RootViewController: UIViewController {
    // dispose combines
    internal var cancelBag = Set<AnyCancellable>()
    
    var navigation: RootNavigationController? {
        get { return (UIApplication.shared.delegate as? AppDelegate)?.rootNavigation }
    }
    
    func atemptToShowStoreReview() {
        if AppSession.shared.shouldShowStoreReview {
            SKStoreReviewController.requestReview()
        }
    }
}
