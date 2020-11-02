//
//  SearchViewTest.swift
//  MusicPediaTests
//
//  Created by Vinicius Bornholdt on 02/11/2020.
//

import XCTest

fileprivate struct SearchRepository_success_test: SearchRepositoryProtocol {
    func getTopAlbuns(search: String, page: Int, completion: @escaping (ResponseResult<[Album], APIError>) -> Void) {}
    
    func getTopTags(completion: @escaping (ResponseResult<[Tag], APIError>) -> Void) {
        let tag = Tag(name: "Tag")
        completion(.success([tag]))
    }
}

fileprivate class SearchViewTest: XCTestCase {

    var viewModel: SearchViewModel!
    let repository = SearchRepository_success_test()
    
    override func setUp() {
        super.setUp()
        
        self.viewModel = SearchViewModel(repository: repository)
    }
    
    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
    }
    
    func testTopTagRequest_success() {
        let  expectation = ExpectationWrapper(description: "load request succes")
        
        viewModel?.onGetTopTagsSuccesEvent = { tagItems in
            expectation.success()
            XCTAssert(!tagItems.isEmpty)
        }
        
        viewModel.getTopTags()
        wait(for: [expectation], timeout: 3)
    }
}
