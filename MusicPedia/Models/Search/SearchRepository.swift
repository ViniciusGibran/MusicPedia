//
//  SearchRepository.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

protocol SearchRepositoryProtocol {
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Void)
    func getTopTags(completion: @escaping (ResponseResult<[Tag], APIError>) -> Void)
}

// TODO: create a proper router to the apis
class SearchRepository: APIRequest, SearchRepositoryProtocol {
        
    func getTopTags(completion: @escaping (ResponseResult<[Tag], APIError>) -> Void) {
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=tag.getTopTags&artist=radiohead&album=the%20bends&api_key=f94d5b07fba72d6e014d0844423a1fd4&format=json")!
        
        fetchDataFrom(url: url)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            }, receiveValue: { data in
                do {
                    let response = try self.decoder.decode(TopTagsResponse.self, from: data)
                    if !response.metadata.tags.isEmpty {
                        completion(.success(response.metadata.tags))
                    } else {
                        completion(.failure(APIError(.notFound)))
                    }
                    
                } catch {
                    completion(.failure(APIError(.unknown)))
                }
            }).store(in: &cancelBag)
    }
    
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Void) {
        
        let encondedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&limit=30&page=\(page)&tag=\(encondedSearch)&api_key=f94d5b07fba72d6e014d0844423a1fd4&format=json")!
        
        fetchDataFrom(url: url)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            }, receiveValue: { data in
                do {
                    
                    guard let responsejson = String(data: data, encoding: .utf8) else { return }
                    print(responsejson)
                    
                    let response = try self.decoder.decode(SearchResponse.self, from: data)
                    if !response.metadata.albums.isEmpty {
                        completion(.success(response.metadata.albums))
                    } else {
                        completion(.failure(APIError(.notFound)))
                    }
                } catch {
                    completion(.failure(APIError(.unknown)))
                }
            }).store(in: &cancelBag)
    }
}
