//
//  AlbumsGridViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class AlbumsGridViewModel {

    // MARK: Properties
    private let repository: SearchRepositoryProtocol
    private var currentSearch: String = ""
    
    var onSearchRequestSuccesEvent: ((_ isFirstPage: Bool) -> Void)?
    var onStateViewChangedEvent: ((_ state: ViewState) -> Void)?
    var isProcessing = false
    
    var albums: [Album] = [] {
        didSet {
            onSearchRequestSuccesEvent?(page == 1)
        }
    }
    
    var page: Int = 1 {
        didSet {
            if page > 1 {
                searchPhotos(isNextPage: true)
            }
        }
    }
    
    var search: String = "" {
        didSet { searchPhotos(isNextPage: false) }
    }
    
    var viewState: ViewState = .none {
        didSet { onStateViewChangedEvent?(viewState) }
    }
    
    // MARK: Init
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: Repository APIs
    func submitSearch(isNextPage: Bool) {
        isProcessing = true
    }
    
    // MARK: Repository
    private func searchPhotos(isNextPage: Bool) {
        isProcessing = true
        if page == 1 { viewState = .loading }
        repository.getTopAlbuns(search: search, page: page) { result in
            
            switch result {
            case .success(let albums):
                
                if albums.isEmpty {
                    self.viewState = .empty
                    return
                }
                
                if isNextPage {
                    self.albums.append(contentsOf: albums)
                } else {
                    self.page = 1
                    self.albums = albums
                }
                
                self.viewState =  .none
                
            case .failure(let error):
                self.viewState = isNextPage ? .errorWithContent(error) : .error(error)
            }
        }
    }
    
    private func updateViewStateWithResponse() {
        viewState = .none
    }
    
    func loadInitialState(){
        viewState = .start
    }
}


