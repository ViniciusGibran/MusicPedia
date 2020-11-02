//
//  File.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

struct Album: Decodable {
    typealias SizeType = (large: String?, extraLarge: String?)
    
    let name: String?
    let playerURL: String?
    let artist: Artist?
    let wiki: Wiki?
    let trackMetadata: TrackMetadata?
    let images: [Image]?
    
    var imageURL: SizeType? {
        get {
            let images = self.images?.filter{ $0.size == "large" || $0.size == "extralarge" }
            let sizes: SizeType = (large: images?.first?.url, extraLarge: images?.last?.url)
            return sizes
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case playerURL = "url"
        case images = "image"
        case trackMetadata = "tracks"
        case name, artist, wiki
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try? container.decode(String.self, forKey: .name)
        self.playerURL = try? container.decode(String.self, forKey: .playerURL)
        self.wiki = try? container.decode(Wiki.self, forKey: .wiki)
        self.images = try? container.decode([Image].self, forKey: .images)
        self.trackMetadata = try? container.decode(TrackMetadata.self, forKey: .trackMetadata)
        
        if let artist = try? container.decodeIfPresent(Artist.self, forKey: .artist) {
            self.artist = artist
        } else {
            artist = nil
        }
    }
    
    struct Image: Decodable {
        var url: String?
        var size: String?
        
        enum CodingKeys: String, CodingKey {
            case url = "#text"
            case size
        }
    }
    
    
    struct TrackMetadata: Decodable {
        let tracks: [Track]?
        
        enum CodingKeys: String, CodingKey {
            case tracks = "track"
        }
    }
    
    struct Track: Decodable {
        let name: String?
    }
    
    struct Wiki: Decodable {
        let published: String?
    }
}
