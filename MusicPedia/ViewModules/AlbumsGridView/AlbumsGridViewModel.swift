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
    private var isProcessing = false
    
    // events closures
    var onSearchRequestSuccesEvent: ((_ isFirstPage: Bool) -> Void)?
    var onStateViewChangedEvent: ((_ state: ViewState) -> Void)?
    
    
    var albums: [Album] = [] {
        didSet {
            onSearchRequestSuccesEvent?(page == 1)
        }
    }
    
    var page: Int = 1 {
        didSet {
            if page > 1 && !isProcessing {
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
                self.isProcessing = false
                
            case .failure(let error):
                self.viewState = isNextPage ? .errorWithContent(error) : .error(error)
                self.isProcessing = false
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


