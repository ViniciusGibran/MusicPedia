//
//  AppCoordinator.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

protocol Coordinator: class {
    func showAlbumsGridView()
}

class AppCoordinator: Coordinator {

    // MARK: Properties
    let window: UIWindow
    var appSession: AppSession?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    private var currentView: UIViewController? {
        get { return window.rootViewController }
        set { UIView.transition(with: self.window,
                                duration: 0.5,
                                options: .transitionCrossDissolve,
                                animations: { self.window.rootViewController = newValue  },
                                completion: nil) }
    }
    
    func showAlbumsGridView() {
        let searchRepository = SearchRepository()
        let viewModel = AlbumsGridViewModel(repository: searchRepository)
        
        let albumGridView = AlbumsGridViewController.init(viewModel: viewModel)
        
        self.currentView = albumGridView
    }
}
