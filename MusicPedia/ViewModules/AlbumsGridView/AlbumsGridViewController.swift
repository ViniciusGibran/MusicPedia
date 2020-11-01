//
//  AlbumsGridViewController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class AlbumsGridViewController: RootViewController {
    
    // MARK: UI Componentes
    let stateView = StateView()
    let searchContainerView = UIView()
    let headerView: HeaderView
    let searchView: SearchView
    let viewModel: AlbumsGridViewModel
    
    var collectionView: UICollectionView? {
        didSet {
            collectionView?.isPrefetchingEnabled = true
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(AlbumCell.self, forCellWithReuseIdentifier: NSStringFromClass(AlbumCell.self))
        }
    }
    
    init(viewModel: AlbumsGridViewModel, searchView: SearchView, headerView: HeaderView) {
        self.viewModel  = viewModel
        self.searchView = searchView
        self.headerView = headerView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        //TODO: organize this
        let backgroundImageView = UIImageView(image: UIImage(named: "cloud-bg")!)
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.pinEdgesToSuperview()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        visualEffectView.alpha = 0.5
        
        view.addSubview(visualEffectView)
        visualEffectView.pinEdgesToSuperview()
        
        self.stateView.isUserInteractionEnabled = false
        self.view.addSubview(stateView)
        stateView.pinEdgesToSuperview()
        
        let waterfallLayout = WaterfallGridLayout()
        waterfallLayout.delegate = self

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: waterfallLayout)
        collectionView.showsVerticalScrollIndicator = false
        
        // review
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
        view.addSubview(collectionView)
        collectionView.pinEdgesToSuperview()
        collectionView.contentInset.top = self.headerView.maxHeight - 15
        collectionView.alpha  = 0.0
        
        collectionView.backgroundColor = .clear
        
        self.collectionView = collectionView
        
        view.addSubview(self.headerView)
        headerView.pinTop()
        headerView.pinLeft()
        headerView.pinRight()
        
        view.addSubview(searchContainerView)
        searchContainerView.pinTop(8, target: headerView)
        searchContainerView.pinLeft()
        searchContainerView.pinRight()
        searchContainerView.pinBottom()
        searchContainerView.isHidden = true
        
        // headerview & searchview
        headerView.delegate = self
        
        self.searchContainerView.addSubview(searchView.view)
        self.searchView.view.pinEdgesToSuperview()
        self.addChild(self.searchView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindEvents()
        self.viewModel.loadInitialState()
    }
    
    private func makeSearch(content: String) {
        self.view.endEditing(true)
        self.headerView.setTextFieldPlaceholder(content)
        self.viewModel.search = content
        
        self.headerView.expand()
        self.headerView.isUserInteractionEnabled = false
        self.searchContainerView.isHidden = true
    }
    
    private func bindEvents() {
        // searchView
        searchView.onTagSelectedEvent = { content in
            self.headerView.setTextFieldPlaceholder(content)
            self.makeSearch(content: content)
        }
        
        // viewModel
        viewModel.onSearchRequestSuccesEvent = { isFirstPage in
            self.updateView(isFirstPage)
        }
        
        // stateView
        viewModel.onStateViewChangedEvent = { state in
            DispatchQueue.main.async {
                self.headerView.isUserInteractionEnabled = true
                self.stateView.updateState(state)
            }
        }
    }
    
    func updateView(_ isFirstPage: Bool) {
        if isFirstPage {
            self.viewModel.isProcessing = false
            self.headerView.isUserInteractionEnabled = true

            self.collectionView?.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: false)
            self.animateCollectionView(shown: true)
        } else {
            self.collectionView?.performBatchUpdates({
                let rows = self.collectionView!.numberOfItems(inSection: 0)
                let newRange = self.viewModel.albums.count - rows
                
                var indexPaths = [IndexPath]()
                for index in 0 ..< newRange {
                    indexPaths.append(IndexPath(row: rows + index, section: 0))
                }
                
                self.collectionView?.insertItems(at: indexPaths)
                
            }, completion: { _ in
                self.headerView.setActivityIndicator()
                self.headerView.isUserInteractionEnabled = true
                self.viewModel.isProcessing = false
            })
        }
        self.view.endEditing(true)
    }
    
    func animateCollectionView(shown: Bool) {
        UIView.animate(withDuration: 0.1) {
            if shown { self.collectionView?.alpha = 1.0}
            else { self.collectionView?.alpha = 0.0 }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumsGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumsGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = NSStringFromClass(AlbumCell.classForCoder())
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AlbumCell
        cell.album = viewModel.albums[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { return }
        let numberOfRows: Double = Double(self.viewModel.albums.count) / Double(indexPath.row)
        if numberOfRows <= 1.5 && !viewModel.isProcessing {
            headerView.setActivityIndicator()
            viewModel.page += 1
        }
    }
}

// MARK: - WaterfallGridLayoutDelegate
extension AlbumsGridViewController: WaterfallGridLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //TODO: review, may not use waterfall grid
        return CGFloat(Int.random(in: 60..<80))
    }
}

// MARK: - HeaderViewDelegate
extension AlbumsGridViewController: HeaderViewDelegate {
    func shouldShowSearchView(_ show: Bool) {
        if show {
            self.stateView.updateState(.none)
            self.headerView.collapse()
            self.searchView.showAnimated()
            self.animateCollectionView(shown: false)
        } else {
            self.headerView.expand()
            self.view.endEditing(true)
        }
        
        self.searchContainerView.isHidden = !show
    }
    
    func didSubmitSearch(_ search: String) {
        makeSearch(content: search)
    }
}

