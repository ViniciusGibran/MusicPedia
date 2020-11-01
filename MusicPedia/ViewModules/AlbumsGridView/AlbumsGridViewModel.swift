//
//  AlbumsGridViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class AlbumsGridViewModel {

    private let repository: SearchRepositoryProtocol
    private var currentSearch: String = ""
    var isProcessing = false
    
    var albums: [Album] = [] {
        didSet {
            // TODO
        }
    }
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: Repository APIs
    func submitSearch(isNextPage: Bool) {
        isProcessing = true
        repository.getTopAlbuns(search: "pink floyd", page: 1) { result in
            
            switch result {
            case .success(let album):
                print(album)
            case .failure(let error):
                print(error.errorDescription)
            }
            
        }
    }
    
}
