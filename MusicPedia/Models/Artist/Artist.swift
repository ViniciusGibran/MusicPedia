//
//  Artist.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

struct Artist: Decodable {
    let name: String?
    let url: String?
    let stats: Stats?
    
    var wikiURL: String? {
        get {
            guard let url = url else { return "https://www.last.fm/error" }
            return "\(url)/+wiki"
        }
    }
    
    struct Stats: Decodable {
        let listeners: String?
        let playCount: String?
        
        enum CodingKeys: String, CodingKey {
            case listeners
            case playCount = "playcount"
        }
    }   
}
