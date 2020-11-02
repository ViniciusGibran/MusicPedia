//
//  SearchResponse.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

struct SearchResponse: Decodable {
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case metadata = "albums"
    }
    
    struct Metadata: Decodable {
        var albums: [Album]
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
    }
}

struct TopTagsResponse: Decodable {
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case metadata = "toptags"
    }
    
    struct Metadata: Decodable {
        var tags: [Tag]
        
        enum CodingKeys: String, CodingKey {
            case tags = "tag"
        }
    }
}
