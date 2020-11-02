//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

class SearchViewModel {
    
    // MARK: Properties
    var onGetTopTagsSuccesEvent: (([String]) -> Void)?
    let repository: SearchRepositoryProtocol
    
    private var tagItems: [String] = [] {
        didSet {
            onGetTopTagsSuccesEvent?(tagItems)
        }
    }
    
    // MARK: Init
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: Repository
    func getTopTags() {
        repository.getTopTags { result in
            switch result {
            case .success(let tags):
                let tagItems = tags.compactMap {$0.name}
                self.tagItems = tagItems
            case .failure(let error):
                 // TODO handle view state
                print(error.errorDescription)
            }
        }
    }
}
