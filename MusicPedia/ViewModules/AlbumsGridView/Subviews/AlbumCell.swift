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
    let titleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.containerView.layer.shadowOpacity = 1.0
        self.containerView.layer.shadowRadius = 5.0
        self.containerView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.masksToBounds = true
        contentView.addSubview(self.containerView)
        self.containerView.pinEdgesToSuperview()
        
        // placeholder
        self.placeholderImageView.image = UIImage(named: "cloud-icon")
        self.placeholderImageView.contentMode = .scaleAspectFit
        self.containerView.addSubview(self.placeholderImageView)
        self.placeholderImageView.centerToSuperView()
        self.placeholderImageView.constraintHeight(30)
        self.placeholderImageView.constraintWidth(30)

        // photo
        self.coverImageView.contentMode = .scaleAspectFill
        self.containerView.addSubview(coverImageView)
        self.coverImageView.pinEdgesToSuperview()
        
        // title label
        let photoTitleContentView = UIView()
        photoTitleContentView.layer.cornerRadius = 6.0
        photoTitleContentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        self.containerView.addSubview(photoTitleContentView)
        photoTitleContentView.pinRight(5)
        photoTitleContentView.pinLeft(5)
        photoTitleContentView.pinBottom(5)
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 11)
        titleLabel.textColor = .slate
        
        photoTitleContentView.addSubview(titleLabel)
        titleLabel.pinRight(3)
        titleLabel.pinLeft(3)
        titleLabel.pinTop(3)
        titleLabel.pinBottom(3)
        
        containerView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        album = nil
    }
    
    var album: Album? {
        didSet {
            if let album = album {
                titleLabel.text = album.name
                titleLabel.superview?.isHidden = album.name == ""
                
                if let url = URL(string: album.imageURL?.extraLarge ?? "") {
                    coverImageView.kf.setImage(with: url)
                }
            }
        }
    }
}

