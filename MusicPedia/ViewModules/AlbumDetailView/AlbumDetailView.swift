//
//  AlbumDetailViewController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class AlbumView: RootViewController {
    
    // MARK: UI components
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .slate
        label.isHidden = true
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "down-arrow"), for: .normal)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.alpha = 0.8
        indicator.startAnimating()
        return indicator
    }()
    
    // Properties
    let viewModel: AlbumViewModel
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        // main view
        self.view.backgroundColor = .lightGray
        
        // ativity indicator
        self.view.addSubview(activityIndicator)
        activityIndicator.centerToSuperView()
        
        // photo
        self.view.addSubview(photoImageView)
        self.photoImageView.pinEdgesToSuperview()
        
        // title label
        let photoTitleContentView = UIView()
        photoTitleContentView.isHidden = true
        photoTitleContentView.layer.cornerRadius = 6.0
        photoTitleContentView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        self.view.addSubview(photoTitleContentView)
        photoTitleContentView.pinRight(7)
        photoTitleContentView.pinLeft(7)
        photoTitleContentView.pinTop(7)
        
        photoTitleContentView.addSubview(photoTitleLabel)
        photoTitleLabel.pinTop(5)
        photoTitleLabel.pinBottom(5)
        photoTitleLabel.pinLeft(5)
        photoTitleLabel.pinRight(5)
        
        // dismiss button
        let dismissButtonContentView = UIView()
        dismissButtonContentView.layer.cornerRadius = 6.0
        dismissButtonContentView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        self.view.addSubview(dismissButtonContentView)
        dismissButtonContentView.pinBottom(20)
        dismissButtonContentView.centerHorizontally()
        
        // note: for some reason pinEdges is not working here
        dismissButtonContentView.addSubview(dismissButton)
        dismissButton.constraintWidth(30)
        dismissButton.constraintHeight(25)
        dismissButton.pinTop(5)
        dismissButton.pinBottom(2)
        dismissButton.pinLeft(9)
        dismissButton.pinRight(9)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindEvents()
    }
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindEvents() {
        activityIndicator.isHidden = false
        viewModel.fetchPhoto { image, title in
            self.photoImageView.image = image
            self.photoTitleLabel.text = title ?? ""
            self.photoTitleLabel.isHidden = title == nil || title == ""
            self.photoTitleLabel.superview?.isHidden = title == nil || title == ""
            self.activityIndicator.isHidden = true
        }
        
        let dismissTap = dismissButton.publisher.share()
        dismissTap
        .sink { _ in
            self.handleDismiss()
        }.store(in: &cancelBag)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}
