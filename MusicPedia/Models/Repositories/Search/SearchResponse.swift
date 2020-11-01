//
//  SearchResponse.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//


class SearchResponse: Decodable {
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case metadata = "topalbums"
    }
    
    struct Metadata: Decodable {
        var albums: [Album]
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
    }
}
