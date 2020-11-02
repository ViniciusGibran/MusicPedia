//
//  AlbumDetailViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit
import Kingfisher

class AlbumViewModel {
    typealias AlbumInfo = (album: Album?, artist: Artist?)

    // MARK: Properties
    var onGetFullAlbumSuccesEvent: ((Album?, Artist?) -> Void)?
    let repository: AlbumRepositoryProtocol
    
    var albumInfo: AlbumInfo {
        didSet {
            onGetFullAlbumSuccesEvent?(albumInfo.album, albumInfo.artist)
        }
    }
    
    init(repository: AlbumRepositoryProtocol, album: Album) {
        self.repository = repository
        self.albumInfo = (album, nil)
    }
    
    // MARK: Repository
    func getFullAlbumInfo() {
         // TODO handle view state
        guard let album = albumInfo.album else { return }
        repository.getFullAlbumInfo(album: album) { result in
            switch result {
            case .success(let albumInfo):
                self.albumInfo = albumInfo
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func getBackgroundCover(compltion: @escaping ((_ image: UIImage?) -> Void)) {
        if let urlString = albumInfo.album?.imageURL?.extraLarge, let url = URL(string: urlString) {

            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    compltion(value.image)
                case .failure(let error):
                     // TODO handle view state
                    print("Error: \(error)")
                }

            }

        }
    }

}

