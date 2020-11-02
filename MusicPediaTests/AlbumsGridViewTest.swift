//
//  AlbumsGridViewTest.swift
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

fileprivate struct SearchRepository_success_test: SearchRepositoryProtocol {
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Void) {
        let album = Album(name: "Album")
        completion(.success([album]))
    }
    
    func getTopTags(completion: @escaping (ResponseResult<[Tag], APIError>) -> Void) {}
}

fileprivate struct SearchRepository_notFound_test: SearchRepositoryProtocol {
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Void) {
        completion(.failure(APIError(.notFound)))
    }
    
    func getTopTags(completion: @escaping (ResponseResult<[Tag], APIError>) -> Void) {}
}

fileprivate class PhotoGridViewTest: XCTestCase {
    
    var viewModel: AlbumsGridViewModel!
    var repository: SearchRepositoryProtocol = SearchRepository_success_test()
    
    override func setUp() {
        super.setUp()
        self.viewModel = AlbumsGridViewModel(repository: repository)
    }
    
    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
    }
    
    func testSearchRequest_success() {
        let  expectation = ExpectationWrapper(description: "load request succes")
        
        viewModel?.onSearchRequestSuccesEvent = { _ in
            expectation.success()
        }
        
        viewModel.search = "test"
        wait(for: [expectation], timeout: 3)
    }
    
    func testSearchRequest_error_notFound() {
        repository = SearchRepository_notFound_test()
        viewModel = AlbumsGridViewModel(repository: repository)
        
        let  expectation = ExpectationWrapper(description: "load request notFound error")
        
        viewModel.onStateViewChangedEvent = { state in
            if case .error(let error) = state {
                if case .notFound = error.errorType {
                    expectation.success()
                }
            }
        }
        
        viewModel.search = "test"
        wait(for: [expectation], timeout: 3)
    }
}
