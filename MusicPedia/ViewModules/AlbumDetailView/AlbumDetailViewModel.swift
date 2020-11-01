//
//  AlbumDetailViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit
import Kingfisher

class AlbumViewModel {

    let album: Album
    
    init(album: Album) {
        self.album = album
    }
    
    func fetchPhoto(compltion: @escaping ((_ imag: UIImage?,_ title: String?) -> Void)) {
        if let urlString = album.imageURL?.extraLarge, let url = URL(string: urlString) {

            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    compltion(value.image, self.album.name)
                case .failure(let error):
                    // TODO
                    print("Error: \(error)")
                }

            }

        }
    }

}

