//
//  SearchRepository.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

protocol SearchRepositoryProtocol {
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Album)
}

class SearchRepository: APIRequest, SearchRepositoryProtocol {
        
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Album) {
        
        let encondedSearch = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        
        // TODO: create router / remove force
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&limit=30&page=\(page)&artist=\(encondedSearch)&api_key=f94d5b07fba72d6e014d0844423a1fd4&format=json")!
        
        fetchDataFrom(url: url)
            .sink(receiveCompletion: { response in
//                if case let .failure(error) = response {
////                    completion(.failure(error))
//                }
            }, receiveValue: { data in
                do {
                    
                    let response = try self.decoder.decode(SearchResponse.self, from: data)
                    if !response.metadata.albums.isEmpty {
//
                    } else {
//                        completion(.success([]))
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            }).store(in: &cancelBag)
    }
}
