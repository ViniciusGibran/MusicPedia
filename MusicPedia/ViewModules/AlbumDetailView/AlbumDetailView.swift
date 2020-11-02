//
//  AlbumDetailViewController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit
import Kingfisher
import SafariServices

class AlbumView: RootViewController {
    
    // MARK: UI components
    let containerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    let coverBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        visualEffectView.alpha = 0.65
        
        return visualEffectView
    }()
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let publishDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let trackCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let artistListenersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let lastFmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("lastFm", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    let wikiButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("Wiki", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
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
    
    // MARK: Init
    init(viewModel: AlbumViewModel) {
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
    override func loadView() {
        super.loadView()
        
        // main view
        view.backgroundColor = .lightGray
        
        // background
        view.addSubview(coverBackgroundImageView)
        coverBackgroundImageView.pinEdgesToSuperview()
        
        // background effect
        view.addSubview(visualEffectView)
        visualEffectView.pinEdgesToSuperview()
        
        // album info container
        view.addSubview(containerView)
        containerView.pinTop(60)
        containerView.pinLeft(30)
        containerView.pinRight(30)
        containerView.pinBottom(150)
        
        // ativity indicator
        view.addSubview(activityIndicator)
        activityIndicator.centerToSuperView()
        
        // cover photo
        containerView.addSubview(coverImageView)
        coverImageView.pinTop(30)
        coverImageView.centerHorizontally()
        coverImageView.constraintHeight(150)
        coverImageView.constraintWidth(150)
        
        // album name
        containerView.addSubview(albumNameLabel)
        albumNameLabel.pinTop(40, target: coverImageView)
        albumNameLabel.pinLeft(20)
        
        // publish date
        containerView.addSubview(publishDateLabel)
        publishDateLabel.pinTop(4, target: albumNameLabel)
        publishDateLabel.pinLeft(20)
        
        // track count
        containerView.addSubview(trackCountLabel)
        trackCountLabel.pinTop(4, target: publishDateLabel)
        trackCountLabel.pinLeft(20)
        
        // Artist name
        containerView.addSubview(artistNameLabel)
        artistNameLabel.pinTop(4, target: trackCountLabel)
        artistNameLabel.pinLeft(20)
        
        // Artist Listeners
        containerView.addSubview(artistListenersLabel)
        artistListenersLabel.pinTop(4, target: artistNameLabel)
        artistListenersLabel.pinLeft(20)
        
        // lastFM button
        containerView.addSubview(lastFmButton)
        lastFmButton.centerHorizontally(-40)
        lastFmButton.pinBottom(10)
        
        // separator
        let buttonsSeparatorView = UIView()
        buttonsSeparatorView.backgroundColor = .white
        containerView.addSubview(buttonsSeparatorView)
        buttonsSeparatorView.centerHorizontally()
        buttonsSeparatorView.pinBottom(20)
        buttonsSeparatorView.constraintHeight(13)
        buttonsSeparatorView.constraintWidth(2)
        
        // wiki button
        containerView.addSubview(wikiButton)
        wikiButton.centerHorizontally(30)
        wikiButton.pinBottom(10)
    
        // dismiss button
        let dismissButtonContentView = UIView()
        dismissButtonContentView.layer.cornerRadius = 6.0
        dismissButtonContentView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        self.view.addSubview(dismissButtonContentView)
        dismissButtonContentView.pinBottom(10)
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
    
    private func bindEvents() {
        
        // viewModel
        viewModel.getBackgroundCover { image in
            DispatchQueue.main.async {
                self.coverBackgroundImageView.image = image
            }
        }
        
        // full album success event
        viewModel.onGetFullAlbumSuccesEvent = { album, artist in
            DispatchQueue.main.async {
                self.updateViewWith(album: album, artist: artist)
            }
        }
        
        // fetch
        viewModel.getFullAlbumInfo()
        
        // dismiss button
        let dismissTap = dismissButton.publisher.share()
        dismissTap.sink { _ in
            self.handleDismiss()
        }.store(in: &cancelBag)
        
        // drag to dismiss
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        // lastfm action
        let lastFMTap = lastFmButton.publisher.share()
        lastFMTap.sink { _ in
            self.openSafariControllerWith(urlString: self.viewModel.albumInfo.album?.playerURL)
        }.store(in: &cancelBag)
        
        // wiki action
        let wikiTap = wikiButton.publisher.share()
        wikiTap.sink { _ in
            self.openSafariControllerWith(urlString: self.viewModel.albumInfo.artist?.wikiURL)
        }.store(in: &cancelBag)
    }
    
    private func updateViewWith(album: Album?, artist: Artist?) {
        if let url = URL(string: album?.imageURL?.large ?? "") {
            self.coverImageView.kf.setImage(with: url)
        }
        
        // album name
        self.albumNameLabel.text = "Album: \(album?.name ?? "")"
        self.albumNameLabel.isHidden = self.albumNameLabel.text == ""
        
        // publish date
        self.publishDateLabel.text = "Publish Date: \(album?.wiki?.published ?? "")"
        self.publishDateLabel.isHidden = self.publishDateLabel.text == ""
        
        // tracks count
        let tracksCount = album?.trackMetadata?.tracks?.count ?? 0
        self.trackCountLabel.text = "Tracks: \(tracksCount)"
        self.trackCountLabel.isHidden = tracksCount == 0
        
        // artist name
        self.artistNameLabel.text = "Artist: \(artist?.name ?? "")"
        self.artistNameLabel.isHidden = self.artistNameLabel.text == ""
        
        // artist listener
        self.artistListenersLabel.text = "Artist Listeners: \(artist?.stats?.listeners ?? "")"
        self.artistListenersLabel.isHidden = self.artistListenersLabel.text == ""
        
        // show content
        self.containerView.isHidden = false
        self.activityIndicator.isHidden = true
    }
    
    private func openSafariControllerWith(urlString: String?) {
        if let url = URL(string: urlString ?? "https://www.last.fm/error") {
            let safariView = SFSafariViewController(url: url)
            present(safariView, animated: true)
        }
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}
