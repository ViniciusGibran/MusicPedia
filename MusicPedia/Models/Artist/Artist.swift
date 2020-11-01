//
//  Artist.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

struct Artist: Decodable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "artist"
    }
}
