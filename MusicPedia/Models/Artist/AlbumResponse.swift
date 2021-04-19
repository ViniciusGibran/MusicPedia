//
//  ArtistResponse.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

struct AlbumResponse: Decodable {
    let album: Album?
}

struct ArtistResponse: Decodable {
    let artist: Artist?
}
