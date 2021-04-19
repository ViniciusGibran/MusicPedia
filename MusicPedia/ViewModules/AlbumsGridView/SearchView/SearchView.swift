//
//  SearchViewController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class SearchView: RootViewController {
    
    // MARK: UIComponents
    var hotTagView: TagView
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.alpha = 0.8
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: Properties
    var viewModel: SearchViewModel
    var onTagSelectedEvent: ((String) -> Void)?
    
    // MARK: Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        self.hotTagView = TagView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .clear
        hotTagView.delegate = self
        
        let hotTagsLabel = UILabel()
        hotTagsLabel.font = .systemFont(ofSize: 20, weight: .medium)
        hotTagsLabel.textColor = .white
        hotTagsLabel.textAlignment = .left
        hotTagsLabel.text = "Top Tags!"
        
        view.addSubview(hotTagsLabel)
        hotTagsLabel.pinLeft(20)
        hotTagsLabel.pinTop(10)
        
        hotTagsLabel.addSubview(activityIndicator)
        activityIndicator.alignTrailing(25, target: hotTagsLabel)
        activityIndicator.centerVertically(inRelationTo: hotTagsLabel)
        
        view.addSubview(hotTagView)
        hotTagView.pinLeft(20)
        hotTagView.pinRight(20)
        hotTagView.pinTop(10, target: hotTagsLabel)
        
        let height = UIScreen.main.bounds.height / 2 - 35
        hotTagView.constraintHeight(height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindEvents()
    }
    
    private func bindEvents() {
        // viewModel
        viewModel.onGetTopTagsSuccesEvent = { tagItems in
            self.hotTagView.tagItems = tagItems
            self.showAnimated()
        }
        
        viewModel.getTopTags()
    }
}

// MARK: - CloudTagViewDelegate
extension SearchView: CloudTagViewDelegate {
    func didSelectTag(content: String) {
        onTagSelectedEvent?(content)
    }
}

// MARK: - Animations
extension SearchView {
    func showAnimated() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.hotTagView.alpha = 0.0
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.activityIndicator.isHidden = true
                self.hotTagView.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
