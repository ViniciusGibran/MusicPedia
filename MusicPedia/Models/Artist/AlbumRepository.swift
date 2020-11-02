//
//  ArtistRepository.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

protocol AlbumRepositoryProtocol {
    func getArtistInfo(name: String, completion: @escaping (ResponseResult<Artist, APIError>) -> Void)
    func getAlbumInfo(album: Album, completion: @escaping (ResponseResult<Album, APIError>) -> Void)
    func getFullAlbumInfo(album: Album, completion: @escaping (ResponseResult<(album: Album, artist: Artist), APIError>) -> Void)
}

// TODO: create a proper router to the apis
class AlbumRepository: APIRequest, AlbumRepositoryProtocol {
    
    func getFullAlbumInfo(album: Album, completion: @escaping (ResponseResult<(album: Album, artist: Artist), APIError>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var albumFull: Album?
        var artistFull: Artist?
        
        dispatchGroup.enter()
        self.getAlbumInfo(album: album) { result in
            switch result {
            case .success(let album):
                albumFull = album
            case .failure(let error):
                completion(.failure(error))
            }
            
            dispatchGroup.leave()
        }
        
        guard let artistName = album.artist?.name else { return completion(.failure(APIError(.notFound))) }
        
        dispatchGroup.enter()
        self.getArtistInfo(name: artistName) { result in
            switch result {
            case .success(let artist):
                artistFull = artist
            case .failure(let error):
                completion(.failure(error))
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print(albumFull ?? "adasdas")
            guard let album = albumFull, let artist = artistFull else { return completion(.failure(APIError(.notFound))) }
            completion(.success((album, artist
            )))
        }
    }
    
    func getAlbumInfo(album: Album, completion: @escaping (ResponseResult<Album, APIError>) -> Void) {
        let encodedArtistName = album.artist?.name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedAlbumName = album.name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=\(encodedArtistName)&album=\(encodedAlbumName)&api_key=f94d5b07fba72d6e014d0844423a1fd4&format=json")!
        
        fetchDataFrom(url: url)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            }, receiveValue: { data in
                do {
                    
                    //debug only
                    guard let responsejson = String(data: data, encoding: .utf8) else { return }
                    print(responsejson)
                    
                    let response = try self.decoder.decode(AlbumResponse.self, from: data)
                    if let album = response.album {
                        completion(.success(album))
                    } else {
                        completion(.failure(APIError(.notFound)))
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError(.unknown)))
                }
            }).store(in: &cancelBag)
    }
    
    func getArtistInfo(name: String, completion: @escaping (ResponseResult<Artist, APIError>) -> Void) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=\(encodedName)&api_key=f94d5b07fba72d6e014d0844423a1fd4&format=json")!
        
        fetchDataFrom(url: url)
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            }, receiveValue: { data in
                do {
                    
                    let response = try self.decoder.decode(ArtistResponse.self, from: data)
                    if let artist = response.artist {
                        completion(.success(artist))
                    } else {
                        completion(.failure(APIError(.notFound)))
                    }
                } catch {
                    completion(.failure(APIError(.unknown)))
                }
            }).store(in: &cancelBag)
    }
}
