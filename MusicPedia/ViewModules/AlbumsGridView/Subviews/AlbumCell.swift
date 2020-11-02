//
//  AlbumCell.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit
import Kingfisher

class AlbumCell: UICollectionViewCell {
    
    // MARK: UI Components
    let containerView = UIView()
    let coverImageView = UIImageView()
    let placeholderImageView = UIImageView()
    let albumNameLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.backgroundColor = .black
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        containerView.pinEdgesToSuperview()
        
        // placeholder
        placeholderImageView.image = UIImage(named: "cloud-icon")
        placeholderImageView.contentMode = .scaleAspectFit
        containerView.addSubview(placeholderImageView)
        placeholderImageView.centerToSuperView()
        placeholderImageView.constraintHeight(30)
        placeholderImageView.constraintWidth(30)

        // photo
        coverImageView.contentMode = .scaleAspectFill
        containerView.addSubview(coverImageView)
        coverImageView.pinTop()
        coverImageView.pinLeft()
        coverImageView.pinRight()
        
        // title label
        let nameContentView = UIView()
        nameContentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.containerView.addSubview(nameContentView)
        nameContentView.pinTop(0, target: coverImageView)
        nameContentView.pinRight()
        nameContentView.pinLeft()
        nameContentView.pinBottom()
        
        albumNameLabel.textAlignment = .center
        albumNameLabel.lineBreakMode = .byWordWrapping
        albumNameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        albumNameLabel.textColor = .white
        
        nameContentView.addSubview(albumNameLabel)
        albumNameLabel.pinRight(5)
        albumNameLabel.pinLeft(5)
        albumNameLabel.pinTop(5)
        albumNameLabel.pinBottom(5)
        
        containerView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        album = nil
    }
    
    var album: Album? {
        didSet {
            if let album = album {
                albumNameLabel.text = album.name
                albumNameLabel.superview?.isHidden = album.name == ""
                
                if let url = URL(string: album.imageURL?.large ?? "") {
                    coverImageView.kf.setImage(with: url)
                }
            }
        }
    }
}

