//
//  File.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

struct Album: Decodable {
    var name: String?
    var playerURL: String?
    var artist: Artist?
    var images: [Image]
    var imageURL: ImageURL?
    
    enum CodingKeys: String, CodingKey {
        case playerURL = "url"
        case images = "image"
    }
    
    struct Image: Decodable {
        var url: String?
        var size: String?
        
        enum CodingKeys: String, CodingKey {
            case url = "#text"
        }
    }
    
    struct ImageURL {
        let large: String
        let extraLarge: String
    }
}
