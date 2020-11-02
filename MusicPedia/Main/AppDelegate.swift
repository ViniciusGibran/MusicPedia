//
//  AppDelegate.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootNavigation: RootNavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = AppCoordinator(window: mainWindow)
        rootNavigation = RootNavigationController(coordinator: coordinator)
        
        rootNavigation?.showAlbumsGridView()
        self.window = mainWindow
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AppSession.end()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppSession.start()
    }
}

