//
//  SearchResponse.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//


class SearchResponse: Decodable {
    let metadata: Metadata
    
    struct Metadata: Decodable {
        var albums: [Album]
        
        enum CodingKeys: String, CodingKey {
            case albums = "topalbums"
        }
    }
}
