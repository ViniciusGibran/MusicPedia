//
//  File.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

struct Album: Decodable {
    typealias SizeType = (large: String?, extraLarge: String?)
    
    var name: String?
    var playerURL: String?
    var artist: Artist?
    var images: [Image]
    
    // TODO: improve this
    var imageURL: SizeType? {
        get {
            let images = self.images.filter{ $0.size == "large" || $0.size == "extralarge" }
            let sizes: SizeType = (large: images.first?.url, extraLarge: images.last?.url)
            return sizes
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case playerURL = "url"
        case images = "image"
        case name
        case artist
    }
    
    struct Image: Decodable {
        var url: String?
        var size: String?
        
        enum CodingKeys: String, CodingKey {
            case url = "#text"
            case size
        }
    }
}
