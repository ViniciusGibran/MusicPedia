//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

class SearchViewModel {
    let repository: SearchRepositoryProtocol
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
//    func fetchHotTags(completion: @escaping (([HotTag]) -> Void)) {
//        repository.getHotTags { tags in
//            completion(tags)
//        }
//
//    }
}
