//
//  AppCoordinator.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

protocol Coordinator: class {
    func showAlbumsGridView()
    func showAlbumView(album: Album) 
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
                                animations: { self.window.rootViewController = newValue },
                                completion: nil) }
    }
    
    func showAlbumsGridView() {
        let searchRepository = SearchRepository()
        let viewModel = AlbumsGridViewModel(repository: searchRepository)
        
        let searchViewModel = SearchViewModel(repository: SearchRepository())
        let searchView = SearchView(viewModel: searchViewModel)
        
        let headerView = HeaderView()
        
        let albumGridView = AlbumsGridView(viewModel: viewModel, searchView: searchView, headerView: headerView)
        
        self.currentView = albumGridView
    }
    
    func showAlbumView(album: Album) {
        let albumRepository = AlbumRepository()
        let albumViewModel = AlbumViewModel(repository: albumRepository, album: album)
        let albumView = AlbumView(viewModel: albumViewModel)
        
        albumView.modalPresentationStyle = .fullScreen
        self.currentView?.present(albumView, animated: true, completion: nil)
    }
}
