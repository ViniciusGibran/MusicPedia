//
//  AlbumsGridViewController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class AlbumsGridViewController: RootViewController {
    
    // MARK: UI Components
    let searchContainerView = UIView()
    
    var collectionView: UICollectionView? {
        didSet {
            collectionView?.isPrefetchingEnabled = true
            // TODO
        }
    }
    
    // MARK: Properties
    let viewModel: AlbumsGridViewModel
    
    init(viewModel: AlbumsGridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.submitSearch(isNextPage: false)
        
        view.backgroundColor = .red
    }
}
