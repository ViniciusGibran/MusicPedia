//
//  AlbumDetailViewTest.swift
//  MusicPediaTests
//
//  Created by Vinicius Bornholdt on 02/11/2020.
//

import XCTest

fileprivate extension Album {
    init(name: String){
        self.name = name
        self.playerURL = nil
        self.artist = nil
        self.wiki = nil
        self.trackMetadata = nil
        self.images = nil
    }
}

fileprivate extension Artist {
    init(name: String) {
        self.name = name
        self.url = nil
        self.stats = nil
    }
}

fileprivate struct AlbumRepository_success_test: AlbumRepositoryProtocol {
    func getArtistInfo(name: String, completion: @escaping (ResponseResult<Artist, APIError>) -> Void) {}
    
    func getAlbumInfo(album: Album, completion: @escaping (ResponseResult<Album, APIError>) -> Void) {}
    
    func getFullAlbumInfo(album: Album, completion: @escaping (ResponseResult<(album: Album, artist: Artist), APIError>) -> Void) {
        let album = Album(name: "Album")
        let artist = Artist(name: "Artist")
        completion(.success((album: album, artist: artist)))
    }
}

fileprivate class AlbumDetailViewTest: XCTestCase {
    var viewModel: AlbumViewModel!
    let repository: AlbumRepositoryProtocol = AlbumRepository_success_test()
    
    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
    }
    
    func testFullAlbumInfo_success() {
        let album = Album(name: "Album")
        viewModel = AlbumViewModel(repository: repository, album: album)
        let expectation = XCTestExpectation(description: "load request succes")
        
        viewModel?.onGetFullAlbumSuccesEvent = { _, _ in
            expectation.fulfill()
        }

        viewModel.getFullAlbumInfo()
        wait(for: [expectation], timeout: 3)
    }
}
